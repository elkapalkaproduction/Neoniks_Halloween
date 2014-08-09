//
//  NSObject+Helps.m
//  halloween
//
//  Created by Andrei Vidrasco on 8/3/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "NSDictionary+Helps.h"

@implementation NSDictionary (Helpers)

- (BOOL)boolValueForKey:(NSString *)key {
    NSString *boolValue = [self objectForKey:key];
    
    return boolValue ? [boolValue boolValue] : NO;
}

@end
