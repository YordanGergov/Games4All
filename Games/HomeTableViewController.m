#import "HomeTableViewController.h"
#import "HomeUITableViewCell.h"
#import "FTDatabaseRequester.h"
#import "Game.h"
#import "FTSpinner.h"
#import "FTUtils.h"

@interface HomeTableViewController ()

@end

@implementation HomeTableViewController

static NSInteger rowHeight = 105;
static NSString *cellIdentifier = @"HomeUITableViewCell";

- (void)viewDidLoad {
    self.title = @"All Games";
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    FTDatabaseRequester *db = [[FTDatabaseRequester alloc] init];
    FTSpinner *spinner = [[FTSpinner alloc] initWithView:self.tableView andSize:70 andScale:2.5f];
    [spinner startSpinning];
    
    __weak HomeTableViewController *weakSelf = self;
    [db getAllActiveGamesWithBlock:^(NSArray *objects, NSError *error) {
        [spinner stopSpinning];
        if(!error) {
            weakSelf.data = [NSMutableArray arrayWithArray:objects];
            [weakSelf.tableView reloadData];
        } else {
            [FTUtils showAlert:@"We are sorry" withMessage:@"We couldn't retrieve the games."];
        }
    }];
}

-(void)goToAddGame{
    [self performSegueWithIdentifier:@"ToAddGame" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeUITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HomeUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Game *game = self.data[indexPath.row];
    cell.labelTitle.text = game.title;
    NSNumber *playTime = game.playTime;
    if ([playTime isEqual:@0]) {
        cell.labelPlayTime.text = @"FREE";
    } else{
        cell.labelPlayTime.text = [NSString stringWithFormat:@"%@ hours", playTime];
    }
    if(game.photo) {
        [game.photo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            cell.imageViewPicture.image = [UIImage imageWithData:data];
        }];
    } else {
        cell.imageViewPicture.image = nil;
    }
    
    [cell setClipsToBounds:YES];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    Game *game = self.data[indexPath.row];
    if ([game.userId.objectId isEqual:[PFUser currentUser].objectId]) {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Game *game = self.data[indexPath.row];
        game.active = 0;
        __weak HomeTableViewController *weakSelf = self;
        [game saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded) {
                [weakSelf.data removeObjectAtIndex:indexPath.row];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [FTUtils showAlert:@"We are sorry" withMessage:@"Unfortunatelly, you can't delete your game game right now"];
            }
        }];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get reference to receipt
    Game *game = [self.data objectAtIndex:indexPath.row];
    
    GameDetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"gameDetails"];
    
    // Pass data to controller
    controller.game = game;
    [self.navigationController pushViewController:controller animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}
@end
