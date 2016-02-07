#import "ProfileViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FTUtils.h"
#import <Parse/Parse.h>
#import "FTSpinner.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    self.title = @"Profile";
    [super viewDidLoad];
    [self getPersonalInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)logoutClicked:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)getPersonalInfo{
    FTSpinner *spinner = [[FTSpinner alloc] initWithView:self.view andSize:70 andScale:2.5f];
    [spinner startSpinning];
    __weak ProfileViewController *weakSelf = self;
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
        [spinner stopSpinning];
        if (error) {
            [FTUtils showAlert:@"We are sorry" withMessage:@"Couldn't fetch your Facebook profile"];
        }
        else {
            NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [FBuser objectID]];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:userImageURL]];
            weakSelf.profilePic.image = [UIImage imageWithData:imageData];
        }
    }];
    PFUser *currUser = [PFUser currentUser];
    self.nameLabel.text = currUser[@"displayName"];;
    self.emailLabel.text =  currUser[@"contactEmail"];
    self.phoneLabel.text =  currUser[@"contactPhone"];
}

@end
