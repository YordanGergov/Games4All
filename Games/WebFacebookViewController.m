#import "WebFacebookViewController.h"

@interface WebFacebookViewController ()

@end

@implementation WebFacebookViewController

- (void)viewDidLoad {
    self.title = @"Facebook profile";
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com/%@", self.facebookId]];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webViewFacebook loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
