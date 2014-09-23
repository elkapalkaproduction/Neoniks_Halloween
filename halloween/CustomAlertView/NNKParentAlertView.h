//
//  NNKParentAlertView.h
//
//  Created by Vidrasco Andrei on 23/8/14.
//  Copyright (c) 2012 Neoniks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef void (^ActionBlock)();

@interface NNKParentAlertView : UIView

- (instancetype)initCustomPopWithFrame:(CGRect)frame
                       completionBlock:(ActionBlock)completionBlock;
- (void)showInView:(UIView *)view;

@end
