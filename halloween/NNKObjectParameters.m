//
//  NNKObjectParameters.m
//  halloween
//
//  Created by Andrei Vidrasco on 8/3/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "NNKObjectParameters.h"
#import "NNKObjectState.h"
#import "Utils.h"

NSString *const NNKType = @"type";
NSString *const NNKAnimationDirectoryPath = @"animationDirectoryPath";
NSString *const NNKFrame = @"frame";
NSString *const NNKIphone4Frame = @"iphone4Frame";
NSString *const NNKIphone5Frame = @"iphone5Frame";
NSString *const NNKIpadFrame = @"ipadFrame";
NSString *const NNKStates = @"states";

@interface NNKObjectParameters ()

@property (strong, nonatomic) NSString *animationDirectoryPath;

@end

@implementation NNKObjectParameters

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _type = NSClassFromString(dict[NNKType]);
        _animationDirectoryPath = dict[NNKAnimationDirectoryPath];
        _frame = [self frameFromDictionary:dict];
        
        NSMutableArray *localStates = [[NSMutableArray alloc] init];
        NSArray *states = dict[NNKStates];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:self.animationDirectoryPath ofType:nil];
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
        
        for (NSDictionary *state in states) {
            NNKObjectState *object = [[NNKObjectState alloc] initWithDictionary:state filesCount:[files count]];
            [localStates addObject:object];
        }
        _states = [NSArray arrayWithArray:localStates];
    }
    
    return self;
}


- (NSArray *)animationImages {
    if (_animationImages) return _animationImages;
    if (!self.animationDirectoryPath) return nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:self.animationDirectoryPath ofType:nil];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    NSMutableArray *localAnimationImages = [[NSMutableArray alloc] initWithCapacity:[files count]];
    
    for (NSString *file in files) {
        UIImage *image = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:file]];
        [localAnimationImages addObject:image];
    }
    _animationImages = [NSArray arrayWithArray:localAnimationImages];
    
    return _animationImages;
}


- (CGRect)frameFromDictionary:(NSDictionary *)dict {
    NSString *frameKey;
    if (isIphone()) {
        if (isIphone5()) {
            frameKey = NNKIphone5Frame;
        } else {
            frameKey = NNKIphone4Frame;
        }
    } else {
        frameKey = NNKIpadFrame;
    }
    NSString *deviceFrame = dict[frameKey];
    NSString *generalFrame = dict[NNKFrame];
    if (deviceFrame) {
        return CGRectFromString(deviceFrame);
    } else if (generalFrame) {
        return CGRectFromString(generalFrame);
    } else {
        return CGRectZero;
    }
}

@end
