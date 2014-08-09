//
//  NNKObjectState.m
//  halloween
//
//  Created by Andrei Vidrasco on 8/3/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "NNKObjectState.h"
#import "NNKObjectAction.h"
#import "Utils.h"

NSString *const NNKAnimateOnStart = @"animateOnStart";
NSString *const NNKBackgroundImagePath = @"backgroundImage";
NSString *const NNKHighlightedImage = @"highlightedImage";
NSString *const NNKInteractive = @"interactive";
NSString *const NNKAutoTransition = @"autoTransition";
NSString *const NNKIdle = @"idle";
NSString *const NNKRepeatCount = @"repeatCount";
NSString *const NNKAutoreverse = @"autoreverse";
NSString *const NNKAutoreverseSound = @"autoreverseSound";
NSString *const NNKSoundPath = @"soundPath";
NSString *const NNKActions = @"actions";
NSString *const NNKPausebleAnimation = @"pausebleAnimation";
NSString *const NNKFirstFrameIndex = @"firstFrameIndex";
NSString *const NNKLastFrameIndex = @"lastFrameIndex";
NSString *const NNKHidden = @"hidden";
NSString *const NNKAnimationSpeed = @"animationSpeed";
NSString *const NNKActionsOnInitState = @"actionsOnInitState";
NSString *const NNKAnimateWithDelay = @"animateWithDelay";
NSString *const NNKTransitionState = @"transitionState";
NSString *const NNKBackward = @"backward";
NSString *const NNKDuration = @"duration";
NSString *const NNKDragable = @"dragable";
NSString *const NNKScaleble = @"scaleble";
NSString *const NNKRotateble = @"rotateble";
NSString *const NNKSetDefaultImageAfterFinishAnimation = @"setDefaultImageAfterFinishAnimation";

@implementation NNKObjectState

- (instancetype)initWithDictionary:(NSDictionary *)dict filesCount:(NSInteger)filesCount {
    self = [super init];
    if (self) {
        _backgroundImage = dict[NNKBackgroundImagePath];
        _highlightedImage = dict[NNKHighlightedImage];
        _soundPath = dict[NNKSoundPath];
        _transitionState = dict[NNKTransitionState];
        _duration  = [dict[NNKDuration] floatValue];
        _repeatCount = [self floatValueForKey:NNKRepeatCount inDictionary:dict];
        _animationSpeed = [self floatValueForKey:NNKAnimationSpeed inDictionary:dict];
        _interactive = [dict boolValueForKey:NNKInteractive];
        _autoTransition = [dict boolValueForKey:NNKAutoTransition];
        _animateOnStart = [dict boolValueForKey:NNKAnimateOnStart];
        _autoreverse = [dict boolValueForKey:NNKAutoreverse];
        _idle = [dict boolValueForKey:NNKIdle];
        _autoreverseSound = [dict boolValueForKey:NNKAutoreverseSound];
        _animateWithDelay = [dict boolValueForKey:NNKAnimateWithDelay];
        _pausebleAnimation = [dict boolValueForKey:NNKPausebleAnimation];
        _backward = [dict boolValueForKey:NNKBackward];
        _hidden = [dict boolValueForKey:NNKHidden];
        _dragable = [dict boolValueForKey:NNKDragable];
        _scaleble = [dict boolValueForKey:NNKScaleble];
        _rotateble = [dict boolValueForKey:NNKRotateble];
        _setDefaultImageAfterFinishAnimation = [dict boolValueForKey:NNKSetDefaultImageAfterFinishAnimation];
        if (dict[NNKFirstFrameIndex] && dict[NNKLastFrameIndex]) {
            _firstFrameIndex = [dict[NNKFirstFrameIndex] integerValue];
            _lastFrameIndex = [dict[NNKLastFrameIndex] integerValue];
        } else {
            _firstFrameIndex = 0;
            _lastFrameIndex = filesCount - 1;
        }
        _actions = [self actionsForKey:NNKActions inDict:dict];
        _actionsOnInitState = [self actionsForKey:NNKActionsOnInitState inDict:dict];
        self.frameDuration = (1.0f / (15.0f * self.animationSpeed));
    }
    
    return self;
}


- (CGFloat)floatValueForKey:(NSString *)key inDictionary:(NSDictionary *)dict {
    NSString *floatValue = dict[key];
    
    return floatValue ? [floatValue floatValue] : 1;
}


- (NSArray *)actionsForKey:(NSString *)key inDict:(NSDictionary *)dict {
    NSMutableArray *localActions = [[NSMutableArray alloc] init];
    NSArray *actions = dict[key];
    for (NSDictionary *action in actions) {
        NNKObjectAction *object = [[NNKObjectAction alloc] initWithDictionary:action];
        [localActions addObject:object];
    }
    
    return [NSArray arrayWithArray:localActions];
}

@end
