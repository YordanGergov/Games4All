#import "GameBidsTableViewController.h"
#import "FTDatabaseRequester.h"
#import "FTUtils.h"
#import "GameBidsUITableViewCell.h"
#import "Meeting.h"
#import "WebFacebookViewController.h"

@interface GameBidsTableViewController ()

@end

@implementation GameBidsTableViewController{
    FTDatabaseRequester *db;
    NSIndexPath *indexPathForApprovedBid;
}
static NSString *cellIdentifier = @"GameBidsUITableViewCell";
static NSString *labelTextApproved;

- (void)setGame:(id)newGame {
    if (_game != newGame) {
        _game = newGame;
    }
}

- (void)viewDidLoad {
    self.title = @"Potential players";
    self.tableView.rowHeight = 44;
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
    db = [[FTDatabaseRequester alloc] init];
    __weak GameBidsTableViewController *weakSelf = self;
    [db getGameBidsForGame:self.game andBlock:^(NSArray *bids, NSError *error) {
        if(!error) {
            weakSelf.bidsData = [NSMutableArray arrayWithArray:bids];
            [weakSelf.tableView reloadData];
        } else {
            [FTUtils showAlert:@"We are sorry" withMessage:@"We can't show you who wants to join your game right now."];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bidsData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GameBidsUITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Meeting *meeting = self.bidsData[indexPath.row];
    PFUser *user = meeting[@"wanterId"];
    cell.labelName.text = [NSString stringWithFormat:@"%@", user[@"displayName"]];
    cell.labelApproved.tag = indexPath.row;
    labelTextApproved = cell.labelApproved.text;
    if (!meeting.approved) {
        cell.labelApproved.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get reference to receipt
    Meeting *meeting = [self.bidsData objectAtIndex:indexPath.row];
    PFUser *user = meeting[@"wanterId"];
    NSString *facebookId = user[@"facebookId"];
    
    WebFacebookViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"webFacebook"];
    
    // Pass data to controller
    controller.facebookId = facebookId;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)longpress:(UILongPressGestureRecognizer*)sender {
    if (sender.state != UIGestureRecognizerStateEnded) {
        return;
    }
    CGPoint point = [sender locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    if (!(indexPath == nil)){
        indexPathForApprovedBid = indexPath;
        Meeting *toBeApprovedMeeting = self.bidsData[indexPath.row];
        if (toBeApprovedMeeting.approved) {
            [FTUtils showAlert:@"Already done" withMessage:@"You have already approved this person"];
        } else if(self.game.active) {
            [[[UIAlertView alloc] initWithTitle:@"Arrange a game" message:@"Are you sure you want to play with this person?" delegate:self cancelButtonTitle:@"Yes, seems legit!" otherButtonTitles:@"No, I will keep looking!", nil] show];
        } else {
            [FTUtils showAlert:@"This game already has players" withMessage:@"You can't game with more than two people at once!"];
        }
    } else {
        [FTUtils showAlert:@"We are sorry" withMessage:@"Something went wrong with your fingers"];
    }
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    Meeting *approvedMeeting = self.bidsData[indexPathForApprovedBid.row];
    approvedMeeting.gameId = self.game;
    if(buttonIndex == 0 && indexPathForApprovedBid){
        __weak GameBidsTableViewController *weakSelf = self;
        [db updateMeetingForApprovalWithMeeting:approvedMeeting andBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded) {
                [FTUtils showAlert:@"Congratulations" withMessage:@"Your game meeting is arranged!"];
                approvedMeeting.approved = @YES;
                weakSelf.game.active = 0;
                GameBidsUITableViewCell* cell = (GameBidsUITableViewCell*)
                [weakSelf.tableView cellForRowAtIndexPath:indexPathForApprovedBid];
                cell.labelApproved.text = labelTextApproved;
            } else {
                [FTUtils showAlert:@"We are sorry" withMessage:@"You can't approve this person right now"];
            }
        }];
    }
}
- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    if (!(indexPath == nil)){
        Meeting *meeting = self.bidsData[indexPath.row];
        if (!meeting.approved) {
            meeting[@"deleted"] = @YES;
            __weak GameBidsTableViewController *weakSelf = self;
            [meeting saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded) {
                    [weakSelf.bidsData removeObjectAtIndex:indexPath.row];
                    [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                } else {
                    [FTUtils showAlert:@"We are sorry" withMessage:@"Something went wrong and we couldn't delete this"];
                }
            }];
        } else {
            [FTUtils showAlert:@"Better keep it" withMessage:@"It would be better to have info about your gaming partner."];
        }
    } else {
        [FTUtils showAlert:@"We are sorry" withMessage:@"Something went wrong with your fingers"];
    }
}
@end
