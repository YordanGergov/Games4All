#import "AddGameViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "Game.h"
#import "DatabaseRequester.h"
#import "Utils.h"
#import "AddGameViewController.h"
#import "Games-Swift.h"

@interface AddGameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextInput;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextInput;
@property (weak, nonatomic) IBOutlet UITextField *playTimeTextInput;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation AddGameViewController{
    float currentLatitude;
    float currentLongitude;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString* adress;
}

- (void)viewDidLoad {
    self.title = @"Add New Game";
    [super viewDidLoad];
    [self initializeLocationManager];
    geocoder = [[CLGeocoder alloc] init];
    self.titleTextInput.delegate = self;
    self.descriptionTextInput.delegate = self;
    
    //UIImage *image = self.imageView.image;
    int r = arc4random() % 5;
    NSString *index = [NSString stringWithFormat:@"%d", r];
    NSString *imgName = [NSString stringWithFormat:@"%@%@%@", @"game", index, @".jpg"];
    UIImage *image = [UIImage imageNamed:imgName];
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    [image drawInRect: CGRectMake(0, 0, 200, 200)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imageView.image = smallImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)takePhoto:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [Utils showAlert:@"We are sorry" withMessage:@"Your device has no camera"];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (IBAction)selectPhoto:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [Utils showAlert:@"We are sorry" withMessage:@"Your source isn't available"];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)addLocationTaped:(id)sender {
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [Utils showAlert:@"We are sorry" withMessage:@"Failed to get your location"];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    //get coordinates
    if (currentLocation != nil) {
        currentLongitude = currentLocation.coordinate.longitude;
        currentLatitude = currentLocation.coordinate.latitude;
    }
    //get adress
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            adress = placemark.thoroughfare;
            [Utils showAlert:@"Location included." withMessage:adress];
        } else {
            NSLog(@"didUpdateToLocation%@", error.debugDescription);
        }
    } ];
    [self.locationManager stopUpdatingLocation];
}
- (IBAction)saveClicked:(id)sender {
    if ([self validateGame]) {
        NSString *title = self.titleTextInput.text;
        NSString *description = self.descriptionTextInput.text;
        NSNumber *playTime = [NSNumber numberWithInt: [self.playTimeTextInput.text intValue]];
        UIImage *image = self.imageView.image;
        
        Game *game = [[Game alloc] init];
        game.userId = [PFUser currentUser];
        game.title = title;
        game.desc = description;
        game.playTime = playTime;
        game.active = YES;
        game.location.longitude = currentLongitude;
        game.location.latitude = currentLatitude;
        game.address = adress;
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
        PFFile *imageFile = [PFFile fileWithData:imageData];
        game.photo = imageFile;
        Reachability *connectionChecker = [[Reachability alloc] init];
        // BOOL connectionAvailable = connectionChecker.isConnectedToNetwork;
        //BOOL connectionAvailable = [ Reachability isConnectedToNetwork];
        if([Reachability isConnectedToNetwork]){
            
            
            DatabaseRequester *db = [[DatabaseRequester alloc] init];
            [db addGameToDbWithGame:game andBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded) {
                    [Utils showAlert:@"Success" withMessage:@"Your game has been published!"];
                    AddGameViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeTableViewController"];
                    
                    [self.navigationController pushViewController:controller animated:YES];
                } else {
                    [Utils showAlert:@"We are sorry" withMessage:@"Your game could not be published!"];
                    NSLog(@"Errorr: %@", error);
                }
            }];
        }
        else{
            [Utils showAlert:@"Error" withMessage:@"No internet connection"];
        }
    }
}

-(void)initializeLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}
-(bool) validateGame{
    NSString *title = self.titleTextInput.text;
    NSString *playTime = self.playTimeTextInput.text;
    NSString *desc = self.descriptionTextInput.text;
    
    if(title.length == 0){
        [Utils showAlert:@"Wrong input" withMessage:@"Title is required"];
        return false;
    }
    if(desc.length > 100){
        [Utils showAlert:@"Wrong input" withMessage:@"Description too long"];
        return  false;
    }
    if(playTime.length == 0 || ![self validatePlayTime:playTime]){
        [Utils showAlert:@"Wrong input" withMessage:@"Play Time is invalid"];
        return false;
    }
    return true;
}
-(BOOL) validatePlayTime: (NSString *) number{
    NSString *regex = @"[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL match = [predicate evaluateWithObject:number];
    return match;
}

@end
