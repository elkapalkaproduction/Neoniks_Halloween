//
//  NNKObjectAction.h
//  halloween
//
//  Created by Andrei Vidrasco on 8/3/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNKObjectAction : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (strong, nonatomic) NSString *actionBehavior;
@property (strong, nonatomic) NSString *selector;
@property (strong, nonatomic) NSString *riseActionObjectId;
@property (strong, nonatomic) NSDictionary *otherValues;

@end
