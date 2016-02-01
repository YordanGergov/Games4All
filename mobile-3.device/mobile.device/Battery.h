
#import <Foundation/Foundation.h>
typedef enum
{
    LiIon,
    NiMH,
    NiCd,
} BatteryType;

@interface Battery : NSObject

@property (strong, nonatomic) NSString* model;
@property NSInteger* hoursIdle;
@property NSInteger* hoursTalk;
@property BatteryType* batteryType;

@end
