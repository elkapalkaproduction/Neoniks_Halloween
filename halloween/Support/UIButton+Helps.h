//
//  UIButton+Helps.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/18/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Helpers)

- (void)addTarget:(id)target onTouchUpInsideWithAction:(SEL)action;
@property (strong, nonatomic) UIImage *image;

@end
