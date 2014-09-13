//
//  DeviceUtils.m
//  halloween
//
//  Created by Andrei Vidrasco on 8/2/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "DeviceUtils.h"

@implementation DeviceUtils

BOOL isIphone5() {
    static BOOL isIphon5;
    static BOOL isInitialized = NO;
    if (!isInitialized) {
        isIphon5 = [DeviceUtils screenSize].width != 480 && isIphone();
        isInitialized = YES;
    }

    return isIphon5;
}


BOOL isIphone() {
    static BOOL isIphon5;
    static BOOL isInitialized = NO;
    if (!isInitialized) {
        isIphon5 = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
        isInitialized = YES;
    }

    return isIphon5;
}


+ (CGSize)screenSize {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return CGSizeMake(screenSize.height, screenSize.width);
    } else {
        return screenSize;
    }
}

@end
