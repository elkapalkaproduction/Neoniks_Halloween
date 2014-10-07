//
//  AdsManager.m
//  halloween
//
//  Created by Andrei Vidrasco on 9/14/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "AdsManager.h"
#import "SoundPlayer.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#ifdef FreeVersion
#import <AdColony/AdColony.h>
#import "ALSdk.h"
#import "ALInterstitialAd.h"
#import <Chartboost/Chartboost.h>
#import "ATConnect.h"
#import <MobileAppTracker/MobileAppTracker.h>
#import <AdSupport/AdSupport.h>
#endif

NSString *const EVENT_MAIN_LANGUAGE_CHANGE = @"EVENT_MAIN_LANGUAGE_CHANGE";
NSString *const EVENT_MAIN_NEONIKS_CLICKED = @"EVENT_MAIN_NEONIKS_CLICKED";
NSString *const EVENT_MAIN_HOW_TO_PLAY_CLICKED = @"EVENT_MAIN_HOW_TO_PLAY_CLICKED";
NSString *const EVENT_MAIN_PLAY_CLICKED = @"EVENT_MAIN_PLAY_CLICKED";

NSString *const EVENT_WHO_ARE_READ_BOOK = @"EVENT_WHO_ARE_READ_BOOK";
NSString *const EVENT_WHO_ARE_FEEDBACK = @"EVENT_WHO_ARE_FEEDBACK";

NSString *const EVENT_PLAY_ANIMATION_CLICKED = @"EVENT_PLAY_ANIMATION_CLICKED";
NSString *const EVENT_PLAY_QUESTION_CLICKED = @"EVENT_PLAY_QUESTION_CLICKED";
NSString *const EVENT_PLAY_QUESTION_READ_BOOK = @"EVENT_PLAY_QUESTION_READ_BOOK";
NSString *const EVENT_PLAY_RETURN_TO_MENU = @"EVENT_PLAY_RETURN_TO_MENU";
NSString *const EVENT_PLAY_NEW_GAME = @"EVENT_PLAY_NEW_GAME";
NSString *const EVENT_PLAY_TAKE_SNAPSHOT = @"EVENT_PLAY_TAKE_SNAPSHOT";

NSString *const EVENT_MAKE_CARD_CAPTIONS = @"EVENT_MAKE_CARD_CAPTIONS";
NSString *const EVENT_MAKE_CARD_SEND = @"EVENT_MAKE_CARD_SEND";
NSString *const EVENT_MAKE_CARD_SAVE = @"EVENT_MAKE_CARD_SAVE";

NSString *const GOOGLE_ANALITYCS_TRACKING_ID = @"UA-33114261-5";

NSString *const AD_COLONY_APP_ID = @"app9ac6a605ffb54530bf";
NSString *const AD_COLONY_START_ZONE_ID = @"vz0f1d6d316154401b98";
NSString *const AD_COLONY_MINUTES_ZONE_ID = @"vz0c0e99d10c5749b78a";

NSString *const CHARTBOOST_APP_ID = @"5414B0Af1873Da39C931Da40";
NSString *const CHARTBOOST_APP_SIGNATURE = @"9b0b9236c73d16956b68b0b375f2b0accd7e0fa2";

NSString *const APPTENTIVE_API_KEY = @"2ebf152d36054ba38048e44ce0d89479266588d68cb637dc990ad7936b5afde6";


@interface AdsManager ()
#ifdef FreeVersion
<AdColonyDelegate, AdColonyAdDelegate, ChartboostDelegate>
#endif

@property (assign, nonatomic) BOOL isPlayingMusic;

@end

@implementation AdsManager

+ (instancetype)sharedManager {
    
    static id sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}


- (void)setupAllLibraries {
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
    [[GAI sharedInstance] trackerWithTrackingId:GOOGLE_ANALITYCS_TRACKING_ID];
#ifdef FreeVersion
    [AdColony configureWithAppID:AD_COLONY_APP_ID
                         zoneIDs:@[AD_COLONY_START_ZONE_ID, AD_COLONY_MINUTES_ZONE_ID]
                        delegate:self
                         logging:NO];
    [ALSdk initializeSdk];
    [Chartboost startWithAppId:CHARTBOOST_APP_ID
                  appSignature:CHARTBOOST_APP_SIGNATURE
                      delegate:self];
    
    [ATConnect sharedConnection].apiKey = APPTENTIVE_API_KEY;
    [MobileAppTracker initializeWithMATAdvertiserId:@"20460"
                                   MATConversionKey:@"e76deeecd77756a4861d9a10389124c7"];
    [MobileAppTracker setAppleAdvertisingIdentifier:[[ASIdentifierManager sharedManager] advertisingIdentifier]
                         advertisingTrackingEnabled:[[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]];
#endif
}


- (void)logEvent:(NSString *)event {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                           action:event
                                                            label:nil
                                                            value:nil] set:@"start" forKey:kGAISessionControl] build]];
}


- (void)showStartVideo {
    [self playVideosWithZone:AD_COLONY_START_ZONE_ID];
}


- (void)showVideoAfterTenMinutes {
    [self playVideosWithZone:AD_COLONY_MINUTES_ZONE_ID];
}


- (void)playVideosWithZone:(NSString *)zone {
#ifdef FreeVersion
    if ([AdColony zoneStatusForZone:zone] == ADCOLONY_ZONE_STATUS_ACTIVE && (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)) {
        [AdColony playVideoAdForZone:zone withDelegate:self];
    } else {
        [ALInterstitialAd show];
        [Chartboost showInterstitial:CBLocationHomeScreen];
    }
#endif
}


- (void)onAdColonyAdStartedInZone:(NSString *)zoneID {
    self.isPlayingMusic = [[SoundPlayer sharedPlayer] isPlayingBackgroundMusic];
    [[SoundPlayer sharedPlayer] pauseBackgroundMusic];
}


- (void)onAdColonyAdAttemptFinished:(BOOL)shown inZone:(NSString *)zoneID {
    if (self.isPlayingMusic) {
        [[SoundPlayer sharedPlayer] playBakgroundMusic];
    }
}

#ifdef FreeVersion

- (void)didDismissInterstitial:(CBLocation)location {
    if (self.isPlayingMusic) {
        [[SoundPlayer sharedPlayer] playBakgroundMusic];
    }
}

- (void)didDisplayInterstitial:(CBLocation)location {
    self.isPlayingMusic = [[SoundPlayer sharedPlayer] isPlayingBackgroundMusic];
    [[SoundPlayer sharedPlayer] pauseBackgroundMusic];
}
#endif


- (void)matDidBecomeActive {
#ifdef NeoniksFree
    [MobileAppTracker measureSession];
#endif
}


- (void)matOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
#ifdef NeoniksFree
    [MobileAppTracker applicationDidOpenURL:[url absoluteString] sourceApplication:sourceApplication];
#endif
}

@end