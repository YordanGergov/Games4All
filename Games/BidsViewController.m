#import "BidsViewController.h"
#import "GameUITableViewCell.h"
#import "HomeUITableViewCell.h"
#import "FTUtils.h"
#import "Meeting.h"
#import "Game.h"
#import "FTSpinner.h"
#import "BidAuthorContactsViewController.h"

@interface BidsViewController ()

@end

@implementation BidsViewController{
    FTSpinner *spinner;
    PFUser *currAuthor;
}

static NSString *cellIdentifier = @"GameUITableViewCell";
static NSInteger rowHeight = 100;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    spinner = [[FTSpinner alloc] initWithView:self.view andSize:70 andScale:2.5f];
    [spinner startSpinning];
}
-(void)afterGettingDataFromDbWithData:(NSArray*) data
                             andError: (NSError*) error {
    [spinner stopSpinning];
    if(!error) {
        self.data = [NSMutableArray arrayWithArray:data];
        [self.tableView reloadData];
    } else {
        [FTUtils showAlert:@"Error" withMessage:@"Sorry, we couldn't retrieve the games."];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GameUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UIButton *yourBtn = (UIButton *) [cell viewWithTag:1];
    [yourBtn setHidden:YES];
    Meeting *bid = self.data[indexPath.row];
    Game *game = (Game *)bid.gameId;
    if(bid.approved == YES){
        [yourBtn setHidden:NO];
        yourBtn.tag = indexPath.row;
        [yourBtn addTarget:self
                    action:@selector(yourButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        
    }
    cell.labelTItle.text = game.title;
    NSNumber *playTime = game.playTime;
    if ([playTime isEqual:@0]) {
        cell.labelPlayTime.text = @"FREE";
    }
    else{
        cell.labelPlayTime.text = [NSString stringWithFormat:@"%@ hours", playTime];
    }    if(game.photo) {
        [game.photo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            cell.image.image = [UIImage imageWithData:data];
        }];
    }
    else {
        cell.image.image = nil;
    }
    
    [cell setClipsToBounds:YES];
    return cell;
}

-(void)yourButtonClicked:(UIButton*)sender
{
    Meeting *bid = self.data[sender.tag];
    
    if(bid.approved == YES){
        BidAuthorContactsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"BidAuthorContactsViewController"];
        Game *game = (Game *)bid.gameId;
        [game.userId fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            PFUser* author = (PFUser *) object;
            controller.author = author;
            [self.navigationController pushViewController:controller animated:YES];
        }];
        
    }
}

-(void) showGameAuthorContacts{
    NSLog(@"Show author contacts");
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}
@end
