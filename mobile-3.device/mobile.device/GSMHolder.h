

#import <Foundation/Foundation.h>

@interface GSMHolder : NSObject
@property (strong, nonatomic) NSMutableArray* gsms;

+(void)initialize;
+(void)getGSMS;
@end
