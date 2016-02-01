
#import <Foundation/Foundation.h>
#import "Display.h"
#import "Battery.h"

@interface GSM : NSObject

@property (strong, nonatomic) NSString* model;
@property double price;
@property (strong, nonatomic) NSString* owner;
@property (strong, nonatomic) NSString* manufacturer;
@property (strong, nonatomic) Battery* battery;
@property (strong, nonatomic) Display* display;

-(instancetype)initWithModel: (NSString*) model andManufacturer: (NSString*) manufacturer;
-(instancetype)initWithModel: (NSString*) model andManufacturer: (NSString*) manufacturer andBattery: (Battery*) battery;
-(instancetype)initWithModel: (NSString*) model andManufacturer: (NSString*) manufacturer andDisplay: (Display*) display;
-(instancetype)initWithModel: (NSString*) model andManufacturer: (NSString*) manufacturer andDisplay: (Display*) display andBattery: (Battery*) battery;

+(GSM*)gsmWithModel: (NSString*) model andManufacturer: (NSString*) manufacturer;
+(GSM*)gsmWithModel: (NSString*) model andManufacturer: (NSString*) manufacturer andBattery: (Battery*) battery;
+(GSM*)gsmWithModel: (NSString*) model andManufacturer: (NSString*) manufacturer andDisplay: (Display*) display;
+(GSM*)gsmWithModel: (NSString*) model andManufacturer: (NSString*) manufacturer andDisplay: (Display*) display andBattery: (Battery*) battery;

-(NSString*) description;

+(GSM*)IPhone5s;

@end
