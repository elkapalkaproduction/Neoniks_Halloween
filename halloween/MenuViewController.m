//
//  ViewController.m
//  halloween
//
//  Created by Andrei Vidrasco on 8/2/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "MenuViewController.h"
#import "Utils.h"
#import "AdsManager.h"

NSString *const halloweenAppID = @"918984559";
NSString *const bookAppID = @"899196882";

@interface MenuViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UIImageView *textImage;
@property (strong, nonatomic) IBOutlet UIImageView *bannerImage;
@property (strong, nonatomic) IBOutlet UIButton *flagButton;
@property (strong, nonatomic) IBOutlet UIButton *whoAreButton;
@property (strong, nonatomic) IBOutlet UIButton *howToButton;
@property (strong, nonatomic) IBOutlet UIButton *rateUsButton;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *playIconButton;
@property (strong, nonatomic) IBOutlet UIButton *siteButton;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTargets];
    [self updateLanguage];
    [self adjustView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[SoundPlayer sharedPlayer] playBakgroundMusic];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[AdsManager sharedManager] showStartVideo];

}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[SoundPlayer sharedPlayer] pauseBackgroundMusic];
}


- (void)changeLanguge {
    [[AdsManager sharedManager] logEvent:EVENT_MAIN_LANGUAGE_CHANGE];
    [[SoundPlayer sharedPlayer] playClick];
    if (isRussian()) {
        setEnglishLanguage();
    } else {
        setRussianLanguage();
    }
    [self updateLanguage];
}


- (void)goToWhoAre {
    [[AdsManager sharedManager] logEvent:EVENT_MAIN_NEONIKS_CLICKED];
    [[SoundPlayer sharedPlayer] playClick];
    [StoryboardUtils presentViewControllerWithStoryboardID:@"who_are_view_controller"
                                        fromViewController:self];
}


- (void)goToHowTo {
    [[AdsManager sharedManager] logEvent:EVENT_MAIN_HOW_TO_PLAY_CLICKED];
    [[SoundPlayer sharedPlayer] playClick];
    [StoryboardUtils presentViewControllerWithStoryboardID:@"how_to_view_controller"
                                        fromViewController:self];
}


- (void)goToRateUs {
    [[SoundPlayer sharedPlayer] playClick];
    NSURL *bookUrl = [NSURL openStoreToAppWithID:halloweenAppID];
    [[UIApplication sharedApplication] openURL:bookUrl];
}


- (void)goToPlay {
    [[AdsManager sharedManager] logEvent:EVENT_MAIN_PLAY_CLICKED];
    [[SoundPlayer sharedPlayer] playClick];
    [StoryboardUtils presentViewControllerWithStoryboardID:@"game_view_controller"
                                        fromViewController:self];
}


- (void)goToSite {
    [[SoundPlayer sharedPlayer] playClick];
    NSURL *bookUrl = [NSURL urlForSite];
    [[UIApplication sharedApplication] openURL:bookUrl];
}


- (void)setupTargets {
    [self.flagButton addTarget:self onTouchUpInsideWithAction:@selector(changeLanguge)];
    [self.whoAreButton addTarget:self onTouchUpInsideWithAction:@selector(goToWhoAre)];
    [self.howToButton addTarget:self onTouchUpInsideWithAction:@selector(goToHowTo)];
    [self.rateUsButton addTarget:self onTouchUpInsideWithAction:@selector(goToRateUs)];
    [self.playButton addTarget:self onTouchUpInsideWithAction:@selector(goToPlay)];
    [self.playIconButton addTarget:self onTouchUpInsideWithAction:@selector(goToPlay)];
    [self.siteButton addTarget:self onTouchUpInsideWithAction:@selector(goToSite)];
}


- (void)updateLanguage {
    self.bannerImage.image = [UIImage imageWithUnlocalizedName:@"menu_banner"];
    self.textImage.image = [UIImage imageWithUnlocalizedName:@"menu_text"];
    self.flagButton.image = [UIImage imageWithUnlocalizedName:@"menu_flag"];
    self.whoAreButton.image = [UIImage imageWithUnlocalizedName:@"menu_who_are"];
    self.howToButton.image = [UIImage imageWithUnlocalizedName:@"menu_how_to"];
    self.rateUsButton.image = [UIImage imageWithUnlocalizedName:@"menu_rate_us"];
    self.playButton.image = [UIImage imageWithUnlocalizedName:@"menu_play"];
    self.siteButton.image = [UIImage imageWithUnlocalizedName:@"menu_site"];
}


- (void)adjustView {
    self.backgroundImage.image = [UIImage backgroundImageWithName:@"menu_fon"];
}

@end
