#import "RejectedBidsViewController.h"
#import "DatabaseRequester.h"
@interface RejectedBidsViewController ()

@end

@implementation RejectedBidsViewController{
    DatabaseRequester* db;
}

- (void)viewDidLoad {
    [self.tabBarController setTitle:@"Rejected Games"];
    self.tableView = self.tableViewRejectedBids;
    [super viewDidLoad];
    db = [[DatabaseRequester alloc] init];
    [db getRejectedBidsForUser:[PFUser currentUser] andBlock:^(NSArray *games, NSError *error) {
        [super afterGettingDataFromDbWithData:games andError:error];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController setTitle:@"Rejected Games"];
}

@end