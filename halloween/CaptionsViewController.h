//
//  CaptionsViewController.h
//  halloween
//
//  Created by Andrei Vidrasco on 8/11/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CaptionsDelegate <NSObject>

- (void)selectCaptionWithIndex:(NSInteger)index;

@end

@interface CaptionsViewController : HalloweenBaseViewController

+ (instancetype)instantiateWithDelegate:(id<CaptionsDelegate>)delegate;

@end
