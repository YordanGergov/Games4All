#import <UIKit/UIKit.h>
#import "Game.h"

@interface GameDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPicture;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDesc;
@property (weak, nonatomic) IBOutlet UILabel *labelPlayTime;
@property (weak, nonatomic) IBOutlet UILabel *labelAuthorName;
@property (weak, nonatomic) IBOutlet UILabel *labelPublished;
@property (strong, nonatomic) Game *game;
- (IBAction)actionWantToGame:(id)sender;

@end
