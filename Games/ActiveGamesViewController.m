#import "ActiveGamesViewController.h"
#import "FTDatabaseRequester.h"
#import "Game.h"
#import "GameBidsTableViewController.h"

@interface ActiveGamesViewController ()

@end

@implementation ActiveGamesViewController{
    FTDatabaseRequester* db;
}

- (void)viewDidLoad {
    self.tableView = self.tableViewActiveGames;
    [super viewDidLoad];
    db = [[FTDatabaseRequester alloc] init];
    [db getActiveGamesForUser:[PFUser currentUser] andBlock:^(NSArray *games, NSError *error) {
        [super afterGettingDataFromDbWithData:games andError:error];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController setTitle:@"Games you game"];
}
@end
