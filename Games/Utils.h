#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject
+(void) showAlert: (NSString*) title
      withMessage: (NSString*) message;
+(NSString *)encodeToBase64String:(UIImage *)image;
+(UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;
+ (BOOL) isConnectionAvailable;
@end
