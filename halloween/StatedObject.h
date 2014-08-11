//
//  StatedObject.h
//  StrangeParcel
//

#import <AVFoundation/AVFoundation.h>
#import "NNKShapedButton.h"
#import "GameViewController.h"
#import "NNKObjectParameters.h"

@class StatedObject;

@protocol StatedObjectDelegate <NSObject>

- (void)objectInteracted:(StatedObject *)object;
- (void)fireSelector:(SEL)selector inObjectId:(NSString *)objectId;

@end

@interface StatedObject : NNKShapedButton

- (id)initWithParameters:(NNKObjectParameters *)parameters delegate:(UIViewController<StatedObjectDelegate> *)aDelegate;
- (void)setupHighlightedImageIfExists;
- (void)cleanResources;
- (void)stopAnimation;

@end
