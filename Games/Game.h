
#import <Parse/Parse.h>

@interface Game : PFObject<PFSubclassing>
@property (nonatomic, strong) PFObject *userId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSNumber *playTime;
@property (nonatomic, strong) NSString *picture;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, strong) PFFile *photo;
@property BOOL active;

+(NSString *)parseClassName;
@end
