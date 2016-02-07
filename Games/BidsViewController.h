#import <UIKit/UIKit.h>

@interface BidsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *data;
-(void)afterGettingDataFromDbWithData:(NSArray*) data
                             andError: (NSError*) error;
@end
