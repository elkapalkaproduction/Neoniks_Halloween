//
//  PopUpAnimations.m
//  halloween
//
//  Created by Andrei Vidrasco on 8/9/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "PopUpAnimations.h"
#import "Utils.h"

NSString *const XFrom = @"XFrom";
NSString *const YFrom = @"YFrom";
NSString *const ZFrom = @"ZFrom";
NSString *const OpacityFrom = @"OpacityFrom";
NSString *const OpacityTo = @"OpacityTo";
NSString *const XTo = @"XTo";
NSString *const YTo = @"YTo";
NSString *const ZTo = @"ZTo";
NSString *const m34 = @"m34";
const CGFloat UtilsAnimationDuration = 0.8;

@implementation PopUpAnimations

+ (void)animationForAppear:(BOOL)show forView:(UIView *)aView withCompletionBlock:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:UtilsAnimationDuration / 2 animations:^{
        aView.alpha = show? 1.f : 0.f;
    } completion:completion];
}


+ (NSDictionary *)animationValuesForFrame:(CGRect)layerFrame fromRight:(BOOL)right toShow:(BOOL)show {
    NSInteger factor = right? 1 : -1;
    
    
    
    CGFloat m34Value = isIphone()? 1.0 / 750 : 1.0 / 1000;
    
    NSNumber *rotationYFromValue = show? @(-M_PI_2 * factor) : @0;
    NSNumber *rotationYToValue = show? @0 : @(-M_PI_2 * factor);
    
    NSNumber *rotationXFromValue = show? @(layerFrame.size.width * factor) : @0;
    NSNumber *rotationXToValue = show? @0 : @(layerFrame.size.width * factor);
    
    NSNumber *rotationZFromValue = show? @(layerFrame.size.width / 2) : @0;
    NSNumber *rotationZToValue = show? @0 : @(layerFrame.size.width / 2);
    NSNumber *opacityFrom = show? @0 : @1;
    NSNumber *opacityTo = show? @1 : @0;
    NSDictionary *dict = @{YFrom: rotationYFromValue,
                           XFrom: rotationXFromValue,
                           ZFrom: rotationZFromValue,
                           YTo: rotationYToValue,
                           XTo: rotationXToValue,
                           ZTo: rotationZToValue,
                           OpacityFrom: opacityFrom,
                           OpacityTo: opacityTo,
                           m34: @(m34Value)};
    
    return dict;
}


+ (void)animationForLayer:(CALayer *)layer values:(NSDictionary *)animationValues {
    CABasicAnimation *rotationY = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationY.duration = UtilsAnimationDuration;
    rotationY.fromValue = animationValues[YFrom];
    rotationY.toValue = animationValues[YTo];
    [layer addAnimation:rotationY forKey:@"transform.rotation.y"];
    
    CABasicAnimation *translationX = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationX.duration = UtilsAnimationDuration;
    translationX.fromValue = animationValues[XFrom];
    translationX.toValue = animationValues[XTo];
    [layer addAnimation:translationX forKey:@"transform.translation.x"];
    
    CABasicAnimation *translationZ = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
    translationZ.duration = UtilsAnimationDuration;
    translationZ.fromValue = animationValues[ZFrom];
    translationZ.toValue = animationValues[ZTo];
    [layer addAnimation:translationZ forKey:@"transform.translation.z"];
    
    layer.opacity = [animationValues[OpacityFrom] floatValue];
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.duration = UtilsAnimationDuration;
    alpha.fromValue = @(layer.opacity);
    layer.opacity = [animationValues[OpacityTo] floatValue];
    alpha.toValue = @(layer.opacity);
    [layer addAnimation:alpha forKey:@"opacity"];
    
    
}


+ (void)animationForAppear:(BOOL)show fromRight:(BOOL)aRight forView:(UIView *)aView withCompletionBlock:(void (^)(void))block {
    CALayer *adContentLayer = aView.layer;
    CGRect layerFrame = adContentLayer.frame;
    NSDictionary *animationValues = [self animationValuesForFrame:layerFrame fromRight:aRight toShow:show];
    CATransform3D layerTransform = CATransform3DIdentity;
    layerTransform.m34 = [animationValues[m34] floatValue];
    adContentLayer.transform = layerTransform;
    [CATransaction begin];
    {
        [CATransaction setCompletionBlock:block];
        [self animationForLayer:adContentLayer values:animationValues];
    }
    [CATransaction commit];
}

@end
