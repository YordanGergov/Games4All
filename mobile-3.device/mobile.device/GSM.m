
#import "GSM.h"

@implementation GSM

@synthesize model = _model;
@synthesize manufacturer = _manufacturer;

-(instancetype)initWithModel: (NSString*) model andManufacturer: (NSString*) manufacturer{
    self = [super init];
    if(self)
    {
        self.model = model;
        self.manufacturer = manufacturer;
        self.price = 0;
        self.owner = nil;
        self.battery = nil;
        self.display = nil;
    }
    
    return self;
}

-(instancetype)initWithModel: (NSString*) model andManufacturer: (NSString*) manufacturer andBattery: (Battery*) battery{
    self = [super init];
    if(self)
    {
        self.model = model;
        self.manufacturer = manufacturer;
        self.price = 0;
        self.owner = nil;
        self.battery = battery;
        self.display = nil;
    }
    
    return self;
}

-(instancetype)initWithModel: (NSString*) model andManufacturer: (NSString*) manufacturer andDisplay: (Display*) display{
    self = [super init];
    if(self)
    {
        self.model = model;
        self.manufacturer = manufacturer;
        self.price = 0;
        self.owner = nil;
        self.battery = nil;
        self.display = display;
    }
    
    return self;
}

-(instancetype)initWithModel: (NSString*) model andManufacturer: (NSString*) manufacturer andBattery: (Battery*) battery andDisplay:(Display*) display{
    self = [super init];
    if(self)
    {
        self.model = model;
        self.manufacturer = manufacturer;
        self.price = 0;
        self.owner = nil;
        self.battery = battery;
        self.display = display;
    }
    
    return self;
}

+(GSM*)gsmWithModel: (NSString*) model andManufacturer: (NSString*) manufacturer;
{
    return [[GSM alloc] initWithModel: (NSString*) model andManufacturer: (NSString*) manufacturer];
}

+(GSM*)gsmWithModel: (NSString*) model andManufacturer: (NSString*) manufacturer andBattery:(Battery *)battery;
{
    return [[GSM alloc] initWithModel: (NSString*) model andManufacturer: (NSString*) manufacturer andBattery: battery];
}

+(GSM*)gsmWithModel: (NSString*) model andManufacturer: (NSString*) manufacturer andDisplay:(Display *)display;
{
    return [[GSM alloc] initWithModel: (NSString*) model andManufacturer: (NSString*) manufacturer andDisplay:display];
}

+(GSM*)gsmWithModel: (NSString*) model andManufacturer: (NSString*) manufacturer andBattery:(Battery *)battery andDisplay:(Display *)display;
{
    return [[GSM alloc] initWithModel: (NSString*) model andManufacturer: (NSString*) manufacturer andBattery: battery andDisplay:display];
}

-(NSString*) description{
    NSString *descrptionString = [NSString stringWithFormat:@"Model: %@ \r Manufacturer: %@ \r Price: %f \r Owner: %@", self.model, self.manufacturer, self.price, self.owner];
    
    return descrptionString;
}

+(GSM*)IPhone5s {
    GSM* iphone5s =[[GSM alloc] initWithModel: @"iPhone5s" andManufacturer: @"Apple"];
    return iphone5s;
}

@end
