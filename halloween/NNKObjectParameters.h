//
//  NNKObjectParameters.h
//  halloween
//
//  Created by Andrei Vidrasco on 8/3/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNKObjectParameters : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (assign, nonatomic) Class type;
@property (strong, nonatomic) NSArray *animationImages;
@property (assign, nonatomic) CGRect frame;
@property (strong, nonatomic) NSArray *states;

@end
