//
//  WhoAreViewController.m
//  halloween
//
//  Created by Andrei Vidrasco on 8/2/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "WhoAreViewController.h"
#import "Utils.h"
#import <MessageUI/MessageUI.h>

@interface WhoAreViewController () <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UIImageView *bannerImage;
@property (strong, nonatomic) IBOutlet UIImageView *textImage;
@property (strong, nonatomic) IBOutlet UIImageView *contributorsImage;
@property (strong, nonatomic) IBOutlet UIButton *siteButton;
@property (strong, nonatomic) IBOutlet UIButton *readButton;
@property (strong, nonatomic) IBOutlet UIButton *feedbackButton;
@property (strong, nonatomic) IBOutlet UIButton *arrowBackButton;

@end

@implementation WhoAreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTargets];
    [self updateLanguage];
    [self adjustView];
}


- (void)goToSite {
    [[SoundPlayer sharedPlayer] playClick];
    NSURL *bookUrl = [NSURL urlForSite];
    [[UIApplication sharedApplication] openURL:bookUrl];
}


- (void)goToRead {
    [[SoundPlayer sharedPlayer] playClick];
    NSURL *bookUrl = [NSURL openStoreToAppWithID:bookAppID];
    [[UIApplication sharedApplication] openURL:bookUrl];
}


- (void)goToFeedback {
    [[SoundPlayer sharedPlayer] playClick];
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [self createMailCompose];
        [self presentViewController:mailCont animated:YES completion:NULL];
    } else {
        NSURL *bookUrl = [NSURL openStoreToAppWithID:halloweenAppID];
        [[UIApplication sharedApplication] openURL:bookUrl];
    }
}


- (void)goToBack {
    [[SoundPlayer sharedPlayer] playClick];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)setupTargets {
    [self.siteButton addTarget:self onTouchUpInsideWithAction:@selector(goToSite)];
    [self.readButton addTarget:self onTouchUpInsideWithAction:@selector(goToRead)];
    [self.feedbackButton addTarget:self onTouchUpInsideWithAction:@selector(goToFeedback)];
    [self.arrowBackButton addTarget:self onTouchUpInsideWithAction:@selector(goToBack)];
}


- (void)updateLanguage {
    self.bannerImage.image = [UIImage imageWithUnlocalizedName:@"who_are_banner"];
    self.textImage.image = [UIImage imageWithUnlocalizedName:@"who_are_text"];
    self.contributorsImage.image = [UIImage imageWithUnlocalizedName:@"who_are_contributors"];
    self.siteButton.image = [UIImage imageWithUnlocalizedName:@"who_are_site"];
    self.readButton.image = [UIImage imageWithUnlocalizedName:@"who_are_read"];
    self.feedbackButton.image = [UIImage imageWithUnlocalizedName:@"who_are_feedback"];
}


- (void)adjustView {
    self.backgroundImage.image = [UIImage backgroundImageWithName:@"who_are_fon"];
}


- (MFMailComposeViewController *)createMailCompose {
    MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
    mailCont.mailComposeDelegate = self;
    if (isRussian()) {
        [mailCont setSubject:@"«Отзыв»"];
    } else {
        [mailCont setSubject:@"Feedback"];
    }
    [mailCont setToRecipients:[NSArray arrayWithObject:@"info@neoniks.com"]];
    [mailCont setMessageBody:@"" isHTML:NO];
    
    return mailCont;
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
