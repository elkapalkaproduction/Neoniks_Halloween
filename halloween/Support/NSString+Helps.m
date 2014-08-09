//
//  NSString+Helps.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/18/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "NSString+Helps.h"
#import "LanguageSettings.h"

@implementation NSString (Helpers)

+ (NSString *)neoniksLocalizedString:(NSString *)input {
    NSString *string = (NSString *)input;
    string = [NSString stringWithFormat:@"%@_%@", string, isRussian() ? @"rus":@"eng"];

    return string;
}

@end
