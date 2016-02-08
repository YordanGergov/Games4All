#import "GameDetailsViewController.h"
#import "DatabaseRequester.h"
#import "Meeting.h"
#import "Utils.h"
#import "Spinner.h"

@interface GameDetailsViewController ()
@end

@implementation GameDetailsViewController{
    DatabaseRequester *db;
}

- (void)viewDidLoad {
    self.title = @"Game Details";
    [super viewDidLoad];
    db = [[DatabaseRequester alloc] init];
    [self configureView];
}

- (void)setGame:(id)newGame {
    if (_game != newGame) {
        _game = newGame;
        [self configureView];
    }
}

- (void)configureView {
    //  NSLog(@"configureView game: %@", self.game);
    if (self.game) {
        Spinner *spinner = [[Spinner alloc] initWithView:self.view andSize:70 andScale:2.5f];
        [spinner startSpinning];
        __weak GameDetailsViewController *weakSelf = self;
        [db getDetailsForGame:self.game andBlock:^(PFObject *object, NSError *error) {
            [spinner stopSpinning];
            if(!error) {
                weakSelf.game = (Game*) object;
                [weakSelf.game.userId fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    [self.game.userId fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        weakSelf.labelAuthorName.text = object[@"displayName"];
                    }];
                }];
                weakSelf.labelTitle.text = self.game.title;
                weakSelf.labelDesc.text = self.game.desc;
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd.MM.yyyy HH:MM:SS"];
                weakSelf.labelPublished.text = [formatter stringFromDate:self.game.createdAt];
                if ([weakSelf.game.playTime isEqual:@0]) {
                    weakSelf.labelPlayTime.text = @"FREE";
                }
                else{
                    weakSelf.labelPlayTime.text = [NSString stringWithFormat:@"%@ hours", self.game.playTime];
                }
                
                if(weakSelf.game.photo) {
                    [weakSelf.game.photo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        weakSelf.imageViewPicture.image = [UIImage imageWithData:data ];
                    }];
                } else {
                    weakSelf.imageViewPicture.image = nil;
                }
            } else {
                [Utils showAlert:@"We are sorry" withMessage:@"Unfortunatelly, we can't show you this game's details right now"];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)actionWantToGame:(id)sender {
    NSString *userId = self.game.userId.objectId;
    NSString *gameId = self.game.objectId;
    NSString *currUserId = [PFUser currentUser].objectId;

    if(!([currUserId isEqual:userId])) {
        [db checkIfAlreadyAppliedForGame:gameId andUser:currUserId andBlock:^(NSArray *meetings, NSError *error) {
            if(!error) {
                if(!(meetings.count > 0)) {
                    Meeting *meeting = [[Meeting alloc] init];
                    meeting.wanterId = [PFUser currentUser];
                    meeting.gameId = self.game;
                    meeting.approved = NO;
                    meeting.deleted = NO;
                    
                    [db addMeetingToDbWithMeeting:meeting andBlock:^(BOOL succeeded, NSError *error) {
                        if(succeeded) {
                            [Utils showAlert:@"Success" withMessage:@"You joined the game!"];
                        } else {
                            [Utils showAlert:@"We are sorry" withMessage:@"Unfortunatelly, couldn't join the game..."];
                            NSLog(@"Error: %@", error);
                        }
                    }];
                } else {
                    [Utils showAlert:@"Already joined" withMessage:@"Happy Gaming!"];
                }
            } else {
                [Utils showAlert:@"We are sorry" withMessage:@"Something went wrong. Check your internet connection."];
            }
        }];
    } else {
        [Utils showAlert:@"That's your game!" withMessage:@"If you want to play alone, why use the app?"];
    }
}
@end
