#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "FTSpinner.h"
#import "FTUtils.h"
#import "ProfileViewController.h"
#import "FTQuoteDispenser.h"
#import <CoreData/CoreData.h>
#import "FTDatabaseRequester.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation LoginViewController{
    UIDynamicAnimator *animator;
}

- (void)viewDidLoad {
    self.title = @"Login";
    [super viewDidLoad];
    [self populateCoreData];
    [self startAsyncTask];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.imageViewCat]];
    gravity.magnitude = 0.01;
    gravity.angle = -M_E;
    [animator addBehavior:gravity];
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.imageViewCat]];
    [collision setTranslatesReferenceBoundsIntoBoundary:YES];
    [animator addBehavior:collision];
}

- (void) populateCoreData{
    if(![self isDBFilled]){
        if ([FTUtils isConnectionAvailable]) {
            NSManagedObjectContext *context = [self managedObjectContext];
            FTDatabaseRequester *db = [[FTDatabaseRequester alloc] init];
            [db getQuotesWithBlock:^(NSArray *objects, NSError *error) {
                for (NSDictionary *obj in objects) {
                    NSString *quoteBody = [obj objectForKey:@"Quote"];
                    NSManagedObject *quote = [NSEntityDescription insertNewObjectForEntityForName:@"Quote" inManagedObjectContext:context];
                    [quote setValue:quoteBody forKey:@"body"];
                }
                [context save:&error];
            }];
        }
    }
}

- (void) startAsyncTask{
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        while (true) {
            BOOL connectionAvailable = [FTUtils isConnectionAvailable];
            if (connectionAvailable != 1) {
                break;
            }
            [NSThread sleepForTimeInterval:2.0];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            FTQuoteDispenser *dispenser = [[FTQuoteDispenser alloc] init];
            [dispenser showQuote];
            [self startAsyncTask];
        });
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (IBAction)fbLoginButtonTaped:(id)sender {
    
    NSArray *permissionsArray = @[ @"user_about_me", @"email", @"user_birthday", @"user_location"];
    FTSpinner *spinner = [[FTSpinner alloc] initWithView:self.view andSize:70 andScale:2.5f];
    [spinner startSpinning];
    
    if ([self isUserLoggedIn]) {
        [spinner stopSpinning];
        [FTUtils showAlert:@"Um.." withMessage:@"You are already logged in"];
    }
    else{
        [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
            [spinner stopSpinning];
            if (!user) {
                NSString *errorMessage = nil;
                if (!error) {
                    NSLog(@"The user cancelled the Facebook login.");
                } else {
                    [FTUtils showAlert:@"We are sorry" withMessage:@"Unable to log in with Facebook"];
                    NSLog(@"An error occurred: %@", error);
                    errorMessage = [error localizedDescription];
                }
            } else {
                if (user.isNew) {
                    NSLog(@"User with facebook signed up and logged in!");
                    [FTUtils showAlert:@"Login sucessfull" withMessage: @"Welcome !"];
                } else {
                    NSLog(@"User with facebook logged in!");
                    [FTUtils showAlert:@"Login sucessfull" withMessage: @"Welcome !"];
                }
            }
        }];
    }
}
- (IBAction)continueTaped:(id)sender {
    if ([self isUserLoggedIn]) {
        PFUser *currUser = [PFUser currentUser];
        if(currUser[@"contactEmail"] != nil && currUser[@"contactPhone"] != nil){
            [self performSegueWithIdentifier:@"ToProfile" sender:self];
        }
        else{
            [self performSegueWithIdentifier:@"ToAddContactInfo" sender:self];
        }
    }else{
        [FTUtils showAlert:@"Please authenticate" withMessage:@"You are not logged in!"];
    }
}
- (IBAction)helpTaped:(id)sender {
    NSString *message = @"Add a game you want to play and people will join!";
    [FTUtils showAlert:@"Hi!" withMessage:message];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (BOOL) isUserLoggedIn{
    if ([PFUser currentUser] &&
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        return true;
    }
    return false;
}

- (BOOL)isDBFilled {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Quote"];
    NSMutableArray *quotes = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if (!quotes) {
        return false;
    }
    if (quotes.count == 0) {
        return false;
    }
    return true;
}

@end
