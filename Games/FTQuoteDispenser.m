#import "FTQuoteDispenser.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "FTDatabaseRequester.h"
@implementation FTQuoteDispenser

- (void) showQuote{
    NSString *title = @"Looks like you lost internet connection, here's a quote:";
    NSString *quote = [self getRandomQuote];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:title
                                                          message:quote
                                                         delegate:self
                                                cancelButtonTitle:@"Wow, so inspiring!"
                                                otherButtonTitles: nil];
    [myAlertView show];
}

- (void) saveQuotesToCoreData{
    NSManagedObjectContext *context = [self managedObjectContext];
    FTDatabaseRequester *db = [[FTDatabaseRequester alloc] init];
    
    [db getQuotesWithBlock:^(NSArray *objects, NSError *error) {
        for (NSDictionary *obj in objects) {
            NSString *quoteBody = [obj objectForKey:@"Quote"];
            NSManagedObject *quote = [NSEntityDescription insertNewObjectForEntityForName:@"Quote" inManagedObjectContext:context];
            [quote setValue:quoteBody forKey:@"body"];
        }
    }];
}

- (NSString *) getRandomQuote{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Quote"];
    NSMutableArray *quotes = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    int r = arc4random() % quotes.count;
    NSManagedObject *loadedQuote = [quotes objectAtIndex:r];
    return [loadedQuote valueForKey:@"body"];
}
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"asdf"])
    {
        NSLog(@"Button 1 was selected.");
    }
    else if([title isEqualToString:@"Button 2"])
    {
        NSLog(@"Button 2 was selected.");
    }
    else if([title isEqualToString:@"Button 3"])
    {
        NSLog(@"Button 3 was selected.");
    }
}
- (NSString *) getRandomQuote2{
    NSArray* quotes = [NSArray arrayWithObjects: @"I didn't know my dad was a construction site thief, but when I got home all the signs were there" , @"My grandfather had the heart of a Lion and a lifetime ban from the Central Park Zoo", nil];
    int r = arc4random() % quotes.count;
    return [quotes objectAtIndex:r];
}

@end
