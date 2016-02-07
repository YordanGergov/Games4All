#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BidAuthorContactsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) PFUser *author;
@end
