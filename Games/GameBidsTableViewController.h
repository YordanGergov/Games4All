#import <UIKit/UIKit.h>
#import "Game.h"

@interface GameBidsTableViewController : UITableViewController<UIGestureRecognizerDelegate, UIAlertViewDelegate>
- (IBAction)longpress:(UILongPressGestureRecognizer*)sender;
- (IBAction)swipe:(UISwipeGestureRecognizer *)sender;
@property (strong, nonatomic) Game *game;
@property (strong, nonatomic) NSMutableArray *bidsData;
@end
