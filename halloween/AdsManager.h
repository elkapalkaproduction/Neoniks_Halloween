//
//  AdsManager.h
//  halloween
//
//  Created by Andrei Vidrasco on 9/14/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *const EVENT_MAIN_LANGUAGE_CHANGE;
NSString *const EVENT_MAIN_NEONIKS_CLICKED;
NSString *const EVENT_MAIN_HOW_TO_PLAY_CLICKED;
NSString *const EVENT_MAIN_PLAY_CLICKED;

NSString *const EVENT_WHO_ARE_READ_BOOK;
NSString *const EVENT_WHO_ARE_FEEDBACK;

NSString *const EVENT_PLAY_ANIMATION_CLICKED;
NSString *const EVENT_PLAY_QUESTION_CLICKED;
NSString *const EVENT_PLAY_QUESTION_READ_BOOK;
NSString *const EVENT_PLAY_RETURN_TO_MENU;
NSString *const EVENT_PLAY_NEW_GAME;
NSString *const EVENT_PLAY_TAKE_SNAPSHOT;

NSString *const EVENT_MAKE_CARD_CAPTIONS;
NSString *const EVENT_MAKE_CARD_SEND;
NSString *const EVENT_MAKE_CARD_SAVE;

@interface AdsManager : NSObject

+ (instancetype)sharedManager;
- (void)setupAllLibraries;
- (void)logEvent:(NSString *)event;
- (void)startLogTime:(NSString *)screenName;
- (void)endLogTime;
- (void)showStartVideo;
- (void)showVideoAfterTenMinutes;
- (void)matDidBecomeActive;
- (void)matOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication;
- (void)LogFacebookEvent;

@end
