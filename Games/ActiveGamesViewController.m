#import "ActiveGamesViewController.h"
#import "DatabaseRequester.h"
#import "Game.h"
#import "GameBidsTableViewController.h"

@interface ActiveGamesViewController ()

@end

@implementation ActiveGamesViewController{
    DatabaseRequester* db;
}

- (void)viewDidLoad {
    self.tableView = self.tableViewActiveGames;
    [super viewDidLoad];
    db = [[DatabaseRequester alloc] init];
    [db getActiveGamesForUser:[PFUser currentUser] andBlock:^(NSArray *games, NSError *error) {
        [super afterGettingDataFromDbWithData:games andError:error];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController setTitle:@"Games you created"];
}
@end
