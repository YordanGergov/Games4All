#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AddGameViewController : UIViewController<CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property CLLocationManager *locationManager;

@end
