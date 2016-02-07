#import "EditProfileViewController.h"
#import "FTUtils.h"
#import "FTDatabaseRequester.h"

@interface EditProfileViewController ()

@property (weak, nonatomic) IBOutlet UITextField *displayNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    self.title = @"Edit Profile";
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)saveTaped:(id)sender {
    NSString *email = self.emailTextField.text;
    NSString *phone = self.phoneTextField.text;
    if(self.displayNameTextField.text.length == 0) {
        [FTUtils showAlert:@"Wrong input" withMessage:@"Invalid name"];
    }
    if(![self emailIsValid:email]){
        [FTUtils showAlert:@"Wrong input" withMessage:@"Invalid email"];
    }
    else if(! [self phoneIsValid:phone]){
        [FTUtils showAlert:@"Wrong input" withMessage:@"Invalid phone number"];
    }
    else{
        PFUser *currUser = [PFUser currentUser];
        currUser[@"displayName"] = self.displayNameTextField.text;
        currUser[@"contactEmail"] = email;
        currUser[@"contactPhone"] = phone;
        [currUser saveInBackground];
        [self performSegueWithIdentifier:@"ToProfile" sender:self];
    }
}
- (BOOL) emailIsValid: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

-(BOOL) phoneIsValid: (NSString*) candidate{
    NSString *phoneRegex = @"[0123456789][0-9]{6}([0-9]{3})?";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:candidate];
}

@end
