
#import <UIKit/UIKit.h>

@interface HomeUITableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelPlayTime;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPicture;
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
