//
//  Utils.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/12/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "PositionUtils.h"

@implementation PositionUtils

void changePositon(CGPoint point, UIView *view) {
    CGRect frame = view.frame;
    frame.origin = point;
    view.frame = frame;
}


void changeSize(CGSize size, UIView *view) {
    CGRect frame = view.frame;
    frame.size = size;
    view.frame = frame;
}


void setXFor(CGFloat x, UIView *view) {
    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
}


void setYFor(CGFloat y, UIView *view) {
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
}


void changeWidth(CGFloat width, UIView *view) {
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}


void changeHeight(CGFloat height, UIView *view) {
    CGRect frame = view.frame;
    frame.size.height = height;
    view.frame = frame;
}


void moveViewHorizontalyWith(CGFloat x, UIView *view) {
    CGRect frame = view.frame;
    frame.origin.x += x;
    view.frame = frame;
}


void moveViewVerticalyWith(CGFloat y, UIView *view) {
    CGRect frame = view.frame;
    frame.origin.y += y;
    view.frame = frame;
}

@end
