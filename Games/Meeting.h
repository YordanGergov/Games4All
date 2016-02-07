
#import <Parse/Parse.h>
#import "Game.h"

@interface Meeting : PFObject<PFSubclassing>
@property (strong, nonatomic) Game *gameId;
@property (strong, nonatomic) PFObject *wanterId;
@property BOOL approved;
@property BOOL deleted;
+(NSString *)parseClassName;
@end
