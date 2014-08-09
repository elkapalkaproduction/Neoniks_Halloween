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

@property (assign, nonatomic) SEL actionBehavior;
@property (assign, nonatomic) SEL selector;
@property (strong, nonatomic) NSString *riseActionObjectId;

@end
