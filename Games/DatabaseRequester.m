
#import "DatabaseRequester.h"

@implementation DatabaseRequester

-(void)addGameToDbWithGame: (Game *) game
                    andBlock: (void (^)(BOOL succeeded, NSError *error)) block{
    [game saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        block(succeeded, error);
    }];
}

-(void)getAllActiveGamesWithBlock: (void (^)(NSArray *objects, NSError *error)) block{
    PFQuery *query = [PFQuery queryWithClassName:Game.parseClassName];
    [query selectKeys:@[@"title", @"playTime", @"picture", @"userId", @"photo"]];
    [query whereKey:@"active" equalTo:@YES];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block(objects, error);
    }];
}

-(void)getDetailsForGame: (Game*) game
                 andBlock: (void (^)(PFObject *object, NSError *error)) block{
    [game fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        block(object, error);
    }];
}

-(void)addMeetingToDbWithMeeting: (Meeting *) meeting
                    andBlock: (void (^)(BOOL succeeded, NSError *error)) block{
    [meeting saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        block(succeeded, error);
    }];
}

-(void)getApprovedBidsForUser: (PFObject*) userId
             andBlock: (void (^)(NSArray *bids, NSError *error)) block{
    [self getBidsForUser:userId andApproved:@YES andDeleted:@NO andBlock:block];
}

-(void)getPendingBidsForUser: (PFObject*) userId
                    andBlock: (void (^)(NSArray *bids, NSError *error)) block{
    [self getBidsForUser:userId andApproved:@NO andDeleted:@NO andBlock:block];
}
-(void)getRejectedBidsForUser: (PFObject*) userId
                     andBlock: (void (^)(NSArray *bids, NSError *error)) block{
    [self getBidsForUser:userId andApproved:@NO andDeleted:@YES andBlock:block];
}

-(void)getActiveGamesForUser:(PFObject*) user
                     andBlock:(void (^)(NSArray *games, NSError *error)) block{
    [self getGamesForUser:user andActive:@YES andBlock:block];
}

-(void)getInactiveGamesForUser:(PFObject*) user
                     andBlock:(void (^)(NSArray *games, NSError *error)) block{
    [self getGamesForUser:user andActive:@NO andBlock:block];
}

-(void)getGameBidsForGame: (PFObject*) game
                     andBlock: (void (^)(NSArray *bids, NSError *error)) block{
    PFQuery *query = [PFQuery queryWithClassName:[Meeting parseClassName]];
    [query whereKey:@"gameId" equalTo:game];
    [query whereKey:@"deleted" equalTo:@NO];
    [query includeKey:@"wanterId"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *bids, NSError *error) {
        block(bids, error);
    }];
}

-(void)getQuotesWithBlock: (void (^)(NSArray *quotes, NSError *error)) block{
    PFQuery *query = [PFQuery queryWithClassName:@"Quotes"];
    [query selectKeys:@[@"Quote"]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *quotes, NSError *error) {
        block(quotes, error);
    }];
}

-(void)updateMeetingForApprovalWithMeeting: (Meeting*) meeting
          andBlock: (void (^)(BOOL succeeded, NSError *error)) block{
    meeting.approved = @YES;
    meeting.gameId.active = 0;
    [meeting saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        block(succeeded, error);
    }];
}

-(void)checkIfAlreadyAppliedForGame: (NSString*) gameId
                             andUser: (NSString*) userId
                            andBlock: (void (^)(NSArray *meetings, NSError *error)) block{
    PFQuery *query = [PFQuery queryWithClassName:[Meeting parseClassName]];
    [query whereKey:@"gameId" equalTo:[PFObject objectWithoutDataWithClassName:[Game parseClassName] objectId:gameId]];
    [query whereKey:@"wanterId" equalTo:[PFObject objectWithoutDataWithClassName:[PFUser parseClassName] objectId:userId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *meetings, NSError *error) {
        block(meetings, error);
    }];
}

//Private methods
-(void)getGamesForUser:(PFObject*) user
              andActive: (id) active
               andBlock:(void (^)(NSArray *games, NSError *error)) block{
    PFQuery *query = [PFQuery queryWithClassName:[Game parseClassName]];
    [query whereKey:@"userId" equalTo:user];
    [query whereKey:@"active" equalTo:active];
    [query findObjectsInBackgroundWithBlock:^(NSArray *games, NSError *error) {
        block(games, error);
    }];
}


-(void)getBidsForUser: (PFObject*) userId
          andApproved: (id) approved
           andDeleted: (id) deleted
             andBlock: (void (^)(NSArray *bids, NSError *error)) block{
    PFQuery *query = [PFQuery queryWithClassName:[Meeting parseClassName]];
    [query whereKey:@"wanterId" equalTo:userId];
    [query whereKey:@"approved" equalTo:approved];
    if([approved isEqualToValue:@NO]) {
        [query whereKey:@"deleted" equalTo:deleted];
    }
    
    [query includeKey:@"gameId"];
    [query includeKey:@"wanterId"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *bids, NSError *error) {
        block(bids, error);
    }];
}
@end
