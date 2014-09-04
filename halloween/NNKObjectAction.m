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
        _actionBehavior = dict[NNKActionBehavior];
        _selector = dict[NNKSelector];
        _riseActionObjectId = dict[NNKRiseActionObjectId];
        NSArray *allKeys = [dict allKeys];
        NSMutableDictionary *otherValues = [[NSMutableDictionary alloc] init];
        for (NSString *key in allKeys) {
            if (!([key isEqualToString:NNKActionBehavior] ||
                  [key isEqualToString:NNKSelector] ||
                  [key isEqualToString:NNKRiseActionObjectId])) {
                [otherValues setObject:dict[key] forKey:key];
            }
        }
        _otherValues = [NSDictionary dictionaryWithDictionary:otherValues];
    }
    
    return self;
}

@end
