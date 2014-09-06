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

NSString *const CharacterInitialPosition = @"CharactersInitialPosition";

NSString *const NNKObjectCat = @"cat";
NSString *const NNKObjectOwl = @"owl";
NSString *const NNKObjectSheep = @"sheep";
NSString *const NNKObjectBat = @"bat";
NSString *const NNKObjectWitch = @"witch";
NSString *const NNKObjectKnight = @"knight";
NSString *const NNKObjectSnail = @"snail";
NSString *const NNKObjectGolbin = @"goblin";
NSString *const NNKObjectPalm1 = @"palm1";
NSString *const NNKObjectPalm2 = @"palm2";

@interface NNKObjectParameters ()

@property (strong, nonatomic) NSString *animationDirectoryPath;
@property (strong, nonatomic) NSDictionary *dict;
@property (strong, nonatomic) NSArray *states;

@end

@implementation NNKObjectParameters

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _dict = dict;
        _frame = [self frameFromDictionary:self.dict];

    }
    
    return self;
}


- (Class)type {
    if (!_type) {
        _type = NSClassFromString(self.dict[NNKType]);
    }
    
    return _type;
}


- (NSString *)animationDirectoryPath {
    if (!_animationDirectoryPath) {
        _animationDirectoryPath = self.dict[NNKAnimationDirectoryPath];
    }
    
    return _animationDirectoryPath;
}


- (NNKObjectState *)stateAtIndex:(NSInteger)index {
    return self.states[index];
}


- (NSInteger)statesCount {
    return [self.states count];
}


- (NSArray *)states {
    if (!_states) {
        NSMutableArray *localStates = [[NSMutableArray alloc] init];
        NSArray *states = self.dict[NNKStates];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:self.animationDirectoryPath ofType:nil];
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
        
        for (NSDictionary *state in states) {
            NNKObjectState *object = [[NNKObjectState alloc] initWithDictionary:state filesCount:[files count]];
            [localStates addObject:object];
        }
        _states = [[NSArray alloc] initWithArray:localStates];

    }
    
    return _states;
}


- (NSArray *)animationImages {
    if (_animationImages) return _animationImages;
    if (!self.animationDirectoryPath) return nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:self.animationDirectoryPath ofType:nil];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    NSMutableArray *localAnimationImages = [[NSMutableArray alloc] initWithCapacity:[files count]];
    
    for (NSString *file in files) {
        UIImage *image = [UIImage imageNamed:[self.animationDirectoryPath stringByAppendingPathComponent:[file stringByDeletingPathExtension]]];
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


+ (NNKObjectParameters *)catObjectParameters {
    return nil;
    NSDictionary *characterInitialPosition = [[NSDictionary alloc] initWithContentsOfURL:[NSURL urlFromLocalizedName:CharacterInitialPosition extension:@"plist"]];
    
    return  [[NNKObjectParameters alloc] initWithDictionary:characterInitialPosition[NNKObjectCat]];
}


+ (NNKObjectParameters *)owlObjectParameters {
    NSDictionary *characterInitialPosition = [[NSDictionary alloc] initWithContentsOfURL:[NSURL urlFromLocalizedName:CharacterInitialPosition extension:@"plist"]];
    
    return  [[NNKObjectParameters alloc] initWithDictionary:characterInitialPosition[NNKObjectOwl]];
}


+ (NNKObjectParameters *)sheepObjectParameters {
    NSDictionary *characterInitialPosition = [[NSDictionary alloc] initWithContentsOfURL:[NSURL urlFromLocalizedName:CharacterInitialPosition extension:@"plist"]];
    
    return [[NNKObjectParameters alloc] initWithDictionary:characterInitialPosition[NNKObjectSheep]];
}


+ (NNKObjectParameters *)batObjectParameters {
    NSDictionary *characterInitialPosition = [[NSDictionary alloc] initWithContentsOfURL:[NSURL urlFromLocalizedName:CharacterInitialPosition extension:@"plist"]];
    
    return [[NNKObjectParameters alloc] initWithDictionary:characterInitialPosition[NNKObjectBat]];
}


+ (NNKObjectParameters *)witchObjectParameters {
    NSDictionary *characterInitialPosition = [[NSDictionary alloc] initWithContentsOfURL:[NSURL urlFromLocalizedName:CharacterInitialPosition extension:@"plist"]];
    
    return  [[NNKObjectParameters alloc] initWithDictionary:characterInitialPosition[NNKObjectWitch]];
}


+ (NNKObjectParameters *)knightObjectParameters {
    NSDictionary *characterInitialPosition = [[NSDictionary alloc] initWithContentsOfURL:[NSURL urlFromLocalizedName:CharacterInitialPosition extension:@"plist"]];
    
    return [[NNKObjectParameters alloc] initWithDictionary:characterInitialPosition[NNKObjectKnight]];
}


+ (NNKObjectParameters *)snailObjectParameters {
    NSDictionary *characterInitialPosition = [[NSDictionary alloc] initWithContentsOfURL:[NSURL urlFromLocalizedName:CharacterInitialPosition extension:@"plist"]];
    
    return [[NNKObjectParameters alloc] initWithDictionary:characterInitialPosition[NNKObjectSnail]];
}


+ (NNKObjectParameters *)goblinObjectParameters {
    NSDictionary *characterInitialPosition = [[NSDictionary alloc] initWithContentsOfURL:[NSURL urlFromLocalizedName:CharacterInitialPosition extension:@"plist"]];
    
    return [[NNKObjectParameters alloc] initWithDictionary:characterInitialPosition[NNKObjectGolbin]];
}


+ (NNKObjectParameters *)palm1ObjectParameters {
    NSDictionary *characterInitialPosition = [[NSDictionary alloc] initWithContentsOfURL:[NSURL urlFromLocalizedName:CharacterInitialPosition extension:@"plist"]];
    
    return [[NNKObjectParameters alloc] initWithDictionary:characterInitialPosition[NNKObjectPalm1]];
}


+ (NNKObjectParameters *)palm2ObjectParameters {
    NSDictionary *characterInitialPosition = [[NSDictionary alloc] initWithContentsOfURL:[NSURL urlFromLocalizedName:CharacterInitialPosition extension:@"plist"]];
    
    return [[NNKObjectParameters alloc] initWithDictionary:characterInitialPosition[NNKObjectPalm2]];
}

@end
