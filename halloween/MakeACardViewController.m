//
//  MakeACardViewController.m
//  halloween
//
//  Created by Andrei Vidrasco on 8/10/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "MakeACardViewController.h"
#import "CaptionsViewController.h"
#import "Utils.h"
#import <MessageUI/MessageUI.h>
#import "AdsManager.h"

#ifndef FreeVersion
#import "NNKParentAlertView.h"
#else
#import "ATConnect.h"
#endif

@interface MakeACardViewController () <MFMailComposeViewControllerDelegate, CaptionsDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *cardImageView;
@property (strong, nonatomic) UIImage *cardImage;
@property (assign, nonatomic) NSInteger cardTextNumber;
@property (strong, nonatomic) IBOutlet UIImageView *bannerImage;
@property (strong, nonatomic) IBOutlet UIImageView *textMessage;
@property (strong, nonatomic) IBOutlet UIButton *siteAddress;
@property (strong, nonatomic) IBOutlet UIButton *captionTextButton;
@property (strong, nonatomic) IBOutlet UIButton *sendTextButton;
@property (strong, nonatomic) IBOutlet UIButton *saveTextButton;
@property (strong, nonatomic) IBOutlet UIView *cardView;

@end

@implementation MakeACardViewController

+ (instancetype)instantiateWithImage:(UIImage *)image {
    MakeACardViewController *card = [[StoryboardUtils storyboard] instantiateViewControllerWithIdentifier:@"make_a_card_view_controller"];
    card.cardImage = image;
    card.cardTextNumber = 1;
    
    return card;

}


- (IBAction)goBack:(id)sender {
    [[SoundPlayer sharedPlayer] playClick];
    [self dismissViewControllerAnimated:YES completion:NULL];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.cardImageView.image = self.cardImage;
    self.textMessage.image = [UIImage imageWithUnlocalizedName:[NSString stringWithFormat:@"make_a_card_text%ld", (long)self.cardTextNumber]];
    self.bannerImage.image = [UIImage imageWithUnlocalizedName:@"make_a_card_banner"];
    self.siteAddress.image = [UIImage imageWithUnlocalizedName:@"menu_site"];
    self.captionTextButton.image = [UIImage imageWithUnlocalizedName:@"make_a_card_captions"];
    self.sendTextButton.image = [UIImage imageWithUnlocalizedName:@"make_a_card_send"];
    self.saveTextButton.image = [UIImage imageWithUnlocalizedName:@"make_a_card_save"];
    [self.siteAddress addTarget:self onTouchUpInsideWithAction:@selector(goToSite)];
#ifdef FreeVersion
    [[ATConnect sharedConnection] engage:@"make_card_clicked" fromViewController:self];
#endif
}


- (UIImage *)captureScreenInRect:(CGRect)captureFrame {
    UIGraphicsBeginImageContextWithOptions(captureFrame.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.cardView.layer renderInContext:context];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return capturedImage;
}


- (IBAction)captions {
    [[AdsManager sharedManager] logEvent:EVENT_MAKE_CARD_CAPTIONS];
    [[SoundPlayer sharedPlayer] playClick];
    CaptionsViewController *captions = [CaptionsViewController instantiateWithDelegate:self];
    captions.view.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    captions.view.frame = captions.view.bounds;
    [StoryboardUtils addViewController:captions onViewController:self];
}


- (void)goToSite {
    [[SoundPlayer sharedPlayer] playClick];
    NSURL *siteUrl = [NSURL urlForSite];
#ifdef FreeVersion
    [[UIApplication sharedApplication] openURL:siteUrl];
#else
    NNKParentAlertView *alertView = [[NNKParentAlertView alloc] initCustomPopWithFrame:self.view.frame
                                                                       completionBlock:^{
                                                                           [[UIApplication sharedApplication] openURL:siteUrl];
                                                                       }];
    [alertView showInView:self.view];
#endif
}


- (MFMailComposeViewController *)createMailFromImage:(UIImage *)image {
    NSData *myData = UIImagePNGRepresentation(image);
    
    MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
    mailCont.mailComposeDelegate = self;
    if (isRussian()) {
        [mailCont setSubject:@"Смешная открытка с Хэллоуином - специально для тебя"];
        [mailCont setMessageBody:@"Смотри, какая смешная открытка у меня получилась! (это из бесплатного приложения 'Неоники и Хэллоуин' для iPad и iPhone).”.\n\nhttp://bit.ly/Halloween_RU" isHTML:NO];
        [mailCont addAttachmentData:myData mimeType:@"image/png" fileName:@"otkrytka_na_halloween.png"];
    } else {
        [mailCont setSubject:@"My awesome Halloween card just for you!"];
        [mailCont setMessageBody:@"Check out this cool greeting card I created with the FREE iPad/iPhone app, Neoniks and Halloween!\n\nhttp://bit.ly/Halloween_US" isHTML:NO];
        [mailCont addAttachmentData:myData mimeType:@"image/png" fileName:@"halloween_card.png"];
    }
    
    return mailCont;
}


- (IBAction)send {
    [[AdsManager sharedManager] logEvent:EVENT_MAKE_CARD_SEND];
    [[SoundPlayer sharedPlayer] playClick];
    UIImage *image = [self captureScreenInRect:self.cardView.bounds];
    MFMailComposeViewController *mailCont = [self createMailFromImage:image];
    if (!mailCont) return;
#ifdef FreeVersion
    [self presentViewController:mailCont animated:YES completion:NULL];
#else
    NNKParentAlertView *alertView = [[NNKParentAlertView alloc] initCustomPopWithFrame:self.view.frame
                                                                       completionBlock:^{
                                                                           [self presentViewController:mailCont animated:YES completion:NULL];
                                                                       }];
    [alertView showInView:self.view];
#endif
}


- (IBAction)save {
    [[AdsManager sharedManager] logEvent:EVENT_MAKE_CARD_SAVE];
    [[SoundPlayer sharedPlayer] playClick];
    UIImage *image = [self captureScreenInRect:self.cardView.bounds];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)selectCaptionWithIndex:(NSInteger)index {
    self.cardTextNumber = index;
    self.textMessage.image = [UIImage imageWithUnlocalizedName:[NSString stringWithFormat:@"make_a_card_text%ld", (long)self.cardTextNumber]];
}

@end
