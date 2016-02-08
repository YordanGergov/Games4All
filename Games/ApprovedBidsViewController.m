#import "ApprovedBidsViewController.h"
#import "DatabaseRequester.h"
#import "GameDetailsViewController.h"

@interface ApprovedBidsViewController ()

@end

@implementation ApprovedBidsViewController{
    DatabaseRequester* db;
}

- (void)viewDidLoad {
    [self.tabBarController setTitle:@"Joined Games"];
    self.tableView = self.tableViewApprovedBids;
    [super viewDidLoad];
    db = [[DatabaseRequester alloc] init];
    [db getApprovedBidsForUser:[PFUser currentUser] andBlock:^(NSArray *games, NSError *error) {
        [super afterGettingDataFromDbWithData:games andError:error];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController setTitle:@"Joined Games"];
}
@end
