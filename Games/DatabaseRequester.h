
#import <Foundation/Foundation.h>
#import "Game.h"
#import "Meeting.h"

@interface DatabaseRequester : NSObject

-(void)addGameToDbWithGame: (Game *) game
                    andBlock: (void (^)(BOOL succeeded, NSError *error)) block;
-(void)getAllActiveGamesWithBlock: (void (^)(NSArray *objects, NSError *error)) block;
-(void)getDetailsForGame: (Game*) game
                 andBlock: (void (^)(PFObject *object, NSError *error)) block;
-(void)addMeetingToDbWithMeeting: (Meeting *) meeting
                  andBlock: (void (^)(BOOL succeeded, NSError *error)) block;
-(void)getApprovedBidsForUser: (PFObject*) userId
             andBlock: (void (^)(NSArray *bids, NSError *error)) block;
-(void)getPendingBidsForUser: (PFObject*) userId
                     andBlock: (void (^)(NSArray *bids, NSError *error)) block;
-(void)getRejectedBidsForUser: (PFObject*) userId
                     andBlock: (void (^)(NSArray *bids, NSError *error)) block;
-(void)getActiveGamesForUser:(PFObject*) user
                     andBlock:(void (^)(NSArray *games, NSError *error)) block;
-(void)getInactiveGamesForUser:(PFObject*) user
                       andBlock:(void (^)(NSArray *games, NSError *error)) block;
-(void)getGameBidsForGame: (PFObject*) game
                   andBlock: (void (^)(NSArray *bids, NSError *error)) block;
-(void)getQuotesWithBlock: (void (^)(NSArray *quotes, NSError *error)) block;
-(void)updateMeetingForApprovalWithMeeting: (Meeting*) meeting
                   andBlock: (void (^)(BOOL succeeded, NSError *error)) block;
-(void)checkIfAlreadyAppliedForGame: (NSString*) gameId
                             andUser: (NSString*) userId
                            andBlock: (void (^)(NSArray *meetings, NSError *error)) block;
@end
