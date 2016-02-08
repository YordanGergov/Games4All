#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Spinner : NSObject
@property float size;
@property float scale;
-(instancetype)initWithView: (UIView*) view
                    andSize: (float) size
                   andScale: (float) scale;
-(void) startSpinning;
-(void) stopSpinning;
@end
