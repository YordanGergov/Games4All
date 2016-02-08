#import "PendingBidsViewController.h"
#import "DatabaseRequester.h"

@interface PendingBidsViewController ()

@end

@implementation PendingBidsViewController{
    DatabaseRequester* db;
}

- (void)viewDidLoad {
    [self.tabBarController setTitle:@"Pendings Game Meetings"];
    self.tableView = self.tableViewPendingBids;
    [super viewDidLoad];
    db = [[DatabaseRequester alloc] init];
    [db getPendingBidsForUser:[PFUser currentUser] andBlock:^(NSArray *games, NSError *error) {
        [super afterGettingDataFromDbWithData:games andError:error];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController setTitle:@"Pending Games"];
}

@end
