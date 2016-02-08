#import "InactiveGamesViewController.h"
#import "DatabaseRequester.h"

@interface InactiveGamesViewController ()

@end

@implementation InactiveGamesViewController{
    DatabaseRequester* db;
}

- (void)viewDidLoad {
    self.tableView = self.tableViewInactiveGames;
    [super viewDidLoad];
    db = [[DatabaseRequester alloc] init];
    [db getInactiveGamesForUser:[PFUser currentUser] andBlock:^(NSArray *games, NSError *error) {
        [super afterGettingDataFromDbWithData:games andError:error];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController setTitle:@"Games you gameed"];
}
@end
