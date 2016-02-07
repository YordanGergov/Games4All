#import "Game.h"

@implementation Game
@dynamic userId;
@dynamic title;
@dynamic desc;
@dynamic playTime;
@dynamic picture;
@dynamic active;
@dynamic address;
@dynamic location;
@dynamic photo;

+(void) load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"Games";
}
@end
