//
//  LanguageSettings.m
//  halloween
//
//  Created by Andrei Vidrasco on 8/2/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "LanguageSettings.h"

NSString *const kLanguage = @"PreferedLanguage";
NSString *const kRussianLanguageTag = @"ru";
NSString *const kEnglishLanguageTag = @"en";

@implementation LanguageSettings

+ (void)setupLanguage {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults stringForKey:kLanguage]) {
        NSString *preferredLanguage = [NSLocale preferredLanguages][0];
        preferredLanguage = [preferredLanguage isEqualToString:kRussianLanguageTag] ? kRussianLanguageTag : kEnglishLanguageTag;
        [userDefaults setObject:preferredLanguage forKey:kLanguage];
    }
}


BOOL isRussian() {
    NSString *savedLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:kLanguage];

    return [savedLanguage isEqualToString:kRussianLanguageTag];
}


BOOL isEnglish() {
    NSString *savedLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:kLanguage];

    return [savedLanguage isEqualToString:kEnglishLanguageTag];
}


void setRussianLanguage() {
    [[NSUserDefaults standardUserDefaults] setObject:kRussianLanguageTag forKey:kLanguage];
}


void setEnglishLanguage() {
    [[NSUserDefaults standardUserDefaults] setObject:kEnglishLanguageTag forKey:kLanguage];
}

@end
