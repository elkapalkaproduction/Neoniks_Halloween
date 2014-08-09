//
//  PopUpAnimations.h
//  halloween
//
//  Created by Andrei Vidrasco on 8/9/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopUpAnimations : NSObject

+ (void)animationForAppear:(BOOL)show forView:(UIView *)aView withCompletionBlock:(void (^)(BOOL finished))completion;
+ (void)animationForAppear:(BOOL)show fromRight:(BOOL)aRight forView:(UIView *)aView withCompletionBlock:(void (^)(void))block;

@end
