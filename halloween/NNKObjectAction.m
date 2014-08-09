//
//  NNKObjectAction.m
//  halloween
//
//  Created by Andrei Vidrasco on 8/3/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "NNKObjectAction.h"

NSString *const NNKActionBehavior = @"actionBehavior";
NSString *const NNKSelector = @"selector";
NSString *const NNKRiseActionObjectId = @"riseActionObjectId";

@implementation NNKObjectAction

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _actionBehavior = NSSelectorFromString(dict[NNKActionBehavior]);
        _selector = NSSelectorFromString(dict[NNKSelector]);
        _riseActionObjectId = dict[NNKRiseActionObjectId];
    }
    
    return self;
}

@end
