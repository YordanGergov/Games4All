#import "FTSpinner.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation FTSpinner{
    UIView *view;
    UIActivityIndicatorView *spinner;
}
-(instancetype)initWithView:(UIView *)currentView andSize:(float)size andScale:(float)scale{
    self = [super init];
    if(self) {
        view = currentView;
        self.size = size;
        self.scale = scale;
        spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0,0,self.size,self.size)];
    }
    return self;
}

-(void) startSpinning{
    CGAffineTransform transform = CGAffineTransformMakeScale(self.scale,self.scale);
    spinner.transform = transform;
    spinner.color = [UIColor blueColor];
    spinner.center = view.center;
    [spinner startAnimating];
    [view addSubview:spinner];

}

-(void) stopSpinning{
    [spinner removeFromSuperview];
}
@end
