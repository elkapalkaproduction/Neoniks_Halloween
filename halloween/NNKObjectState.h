//
//  NNKObjectState.h
//  halloween
//
//  Created by Andrei Vidrasco on 8/3/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNKObjectState : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict filesCount:(NSInteger)filesCount;

@property (strong, nonatomic) NSString *backgroundImage;
@property (strong, nonatomic) NSString *soundPath;
@property (assign, nonatomic) CGFloat repeatCount;
@property (assign, nonatomic) CGFloat animationSpeed;
@property (assign, nonatomic) CGFloat frameDuration;
@property (assign, nonatomic) CGFloat duration;

@property (assign, nonatomic) NSInteger firstFrameIndex;
@property (assign, nonatomic) NSInteger lastFrameIndex;
@property (strong, nonatomic) NSString *transitionState;
@property (strong, nonatomic) NSString *highlightedImage;

@property (assign, nonatomic) BOOL animateOnStart;
@property (assign, nonatomic) BOOL interactive;
@property (assign, nonatomic) BOOL autoTransition;
@property (assign, nonatomic) BOOL idle;
@property (assign, nonatomic) BOOL autoreverse;
@property (assign, nonatomic) BOOL autoreverseSound;
@property (assign, nonatomic) BOOL pausebleAnimation;
@property (assign, nonatomic) BOOL hidden;
@property (assign, nonatomic) BOOL animateWithDelay;
@property (assign, nonatomic) BOOL shouldBringToFront;
@property (assign, nonatomic) BOOL dragable;
@property (assign, nonatomic) BOOL scaleble;
@property (assign, nonatomic) BOOL rotateble;
@property (assign, nonatomic) BOOL setDefaultImageAfterFinishAnimation;
@property (assign, nonatomic) BOOL backward;

@property (strong, nonatomic) NSArray *actions;
@property (strong, nonatomic) NSArray *actionsOnInitState;

@end
