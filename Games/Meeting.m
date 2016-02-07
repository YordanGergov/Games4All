#import "Meeting.h"

@implementation Meeting
@dynamic  gameId;
@dynamic wanterId;
@dynamic approved;
@dynamic deleted;

+(void) load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"Meetings";
}
@end
