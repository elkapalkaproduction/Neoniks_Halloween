//
//  StoryboardUtils.m
//  halloween
//
//  Created by Andrei Vidrasco on 8/2/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "StoryboardUtils.h"
#import "DeviceUtils.h"

@implementation StoryboardUtils

+ (void)presentViewControllerWithStoryboardID:(NSString *)storyboardId
                           fromViewController:(UIViewController *)viewController {
    
    
    UIViewController *vc = [[StoryboardUtils storyboard] instantiateViewControllerWithIdentifier:storyboardId];
    [viewController presentViewController:vc animated:YES completion:NULL];
}


+ (UIStoryboard *)storyboard {
    UIStoryboard *storyboard;
    if (isIphone()) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    }
    
    return storyboard;
}


+ (void)addViewController:(UIViewController *)childView onViewController:(UIViewController *)parentView {
    [childView willMoveToParentViewController:parentView];
    [parentView addChildViewController:childView];
    [childView didMoveToParentViewController:parentView];
    [parentView.view addSubview:childView.view];
}

@end
