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
        isIphon5 = [UIScreen mainScreen].bounds.size.height == 568;
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

@end
