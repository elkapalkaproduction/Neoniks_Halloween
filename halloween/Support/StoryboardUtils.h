//
//  StoryboardUtils.h
//  halloween
//
//  Created by Andrei Vidrasco on 8/2/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryboardUtils : NSObject

+ (void)presentViewControllerWithStoryboardID:(NSString *)storyboardId
                           fromViewController:(UIViewController *)viewController;

+ (UIStoryboard *)storyboard;

+ (void)addViewController:(UIViewController *)childView onViewController:(UIViewController *)parentView;

@end
