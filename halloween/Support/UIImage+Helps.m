//
//  UIImage+Helps.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/18/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "UIImage+Helps.h"
#import "NSString+Helps.h"
#import "DeviceUtils.h"

@implementation UIImage (Helpers)

+ (UIImage *)backgroundImageWithName:(NSString *)name {
    if (!name) return nil;
    NSString *imageName = name;
    if (isIphone5()) {
        imageName = [name stringByAppendingString:@"-568"];
    }
    
    return [UIImage imageNamed:imageName];
}


+ (UIImage *)imageWithUnlocalizedName:(NSString *)name {
    if (!name) return nil;
    NSString *localizedString = [NSString neoniksLocalizedString:name];

    return [UIImage imageWithLocalizedName:localizedString];
}


+ (UIImage *)imageWithLocalizedName:(NSString *)name {
    if (!name) return nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];

    return [UIImage imageWithContentsOfFile:path];
}

@end
