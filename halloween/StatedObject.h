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
- (void)fireSelector:(NSString *)stringSelector inObjectId:(NSObject *)objectId;

@end

@interface StatedObject : NNKShapedButton

- (id)initWithParameters:(NNKObjectParameters *)parameters delegate:(UIViewController<StatedObjectDelegate> *)aDelegate;
- (void)setupHighlightedImageIfExists;
- (void)cleanResources;
- (void)stopAnimation;

- (void)performActions;

@property (weak, nonatomic) UIViewController<StatedObjectDelegate> *delegate;
@property (strong, nonatomic) NNKObjectParameters *parameters;

@end
