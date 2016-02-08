#import "GamesHistoryViewController.h"
#import "HomeUITableViewCell.h"
#import "Utils.h"
#import "Game.h"
#import "GameBidsTableViewController.h"
#import "Spinner.h"

@interface GamesHistoryViewController ()

@end

@implementation GamesHistoryViewController{
    Spinner *spinner;
}

static NSString *cellIdentifier = @"HomeUITableViewCell";
static NSInteger rowHeight = 100;
- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
    spinner = [[Spinner alloc] initWithView:self.view andSize:70 andScale:2.5f];
    [spinner startSpinning];
}
-(void)afterGettingDataFromDbWithData:(NSArray*) data
                             andError: (NSError*) error {
    [spinner stopSpinning];
    if(!error) {
        self.data = [NSMutableArray arrayWithArray:data];
        [self.tableView reloadData];
    } else {
        [Utils showAlert:@"Error" withMessage:@"Sorry, we couldn't retrieve the games."];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Game *game = self.data[indexPath.row];
    cell.labelTitle.text = game.title;
    NSNumber *playTime = game.playTime;
    if ([playTime isEqual:@0]) {
        cell.labelPlayTime.text = @"FREE";
    }
    else{
        cell.labelPlayTime.text = [NSString stringWithFormat:@"%@ hours", playTime];
    }
    if(game.photo) {
        [game.photo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            cell.imageViewPicture.image = [UIImage imageWithData:data ];
        }];
    } else {
        cell.imageViewPicture.image = nil;
    }
    
    [cell setClipsToBounds:YES];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Game *game = [self.data objectAtIndex:indexPath.row];
    
    GameBidsTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"GameBidsController"];
    
    [controller setGame:game];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
