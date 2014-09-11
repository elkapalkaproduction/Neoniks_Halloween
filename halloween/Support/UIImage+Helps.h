//
//  UIImage+Helps.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/18/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helpers)

+ (UIImage *)backgroundImageWithName:(NSString *)name;
+ (UIImage *)imageWithUnlocalizedName:(NSString *)name;
+ (UIImage *)imageWithLocalizedName:(NSString *)name;

@end
