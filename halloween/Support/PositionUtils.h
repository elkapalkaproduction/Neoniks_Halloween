//
//  Utils.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/12/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface PositionUtils : NSObject

void changePositon(CGPoint point, UIView *view);
void changeSize(CGSize size, UIView *view);

void setXFor(CGFloat x, UIView *view);
void setYFor(CGFloat y, UIView *view);

void changeWidth(CGFloat width, UIView *view);
void changeHeight(CGFloat height, UIView *view);

void moveViewHorizontalyWith(CGFloat x, UIView *view);
void moveViewVerticalyWith(CGFloat y, UIView *view);

@end
