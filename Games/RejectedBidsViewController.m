#import "RejectedBidsViewController.h"
#import "FTDatabaseRequester.h"
@interface RejectedBidsViewController ()

@end

@implementation RejectedBidsViewController{
    FTDatabaseRequester* db;
}

- (void)viewDidLoad {
    [self.tabBarController setTitle:@"Rejected Games"];
    self.tableView = self.tableViewRejectedBids;
    [super viewDidLoad];
    db = [[FTDatabaseRequester alloc] init];
    [db getRejectedBidsForUser:[PFUser currentUser] andBlock:^(NSArray *games, NSError *error) {
        [super afterGettingDataFromDbWithData:games andError:error];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController setTitle:@"Rejected Games"];
}

@end