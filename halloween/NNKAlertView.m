//
//  NNKAlertView.m
//  halloween
//
//  Created by Andrei Vidrasco on 9/13/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "NNKAlertView.h"
#import "UIImage+Helps.h"
#import "UIButton+Helps.h"
#import "StoryboardUtils.h"
#import "DeviceUtils.h"

@interface NNKAlertView ()
@property (weak, nonatomic) IBOutlet UIView *embedView;
@property (weak, nonatomic) IBOutlet UIImageView *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) UIViewController<NNKAlertViewDelegate> *delegate;

@end

@implementation NNKAlertView

+ (instancetype)initWithMessageType:(AlertViewMessage)messageType
                     delegate:(UIViewController<NNKAlertViewDelegate> *)delegate {
    NNKAlertView *alertView = [[StoryboardUtils storyboard] instantiateViewControllerWithIdentifier:@"alertView"];
    alertView.messageType = messageType;
    alertView.delegate = delegate;
    
    return alertView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, [DeviceUtils screenSize].width, [DeviceUtils screenSize].height);
    NSString *message = [NSString stringWithFormat:@"alert_message_%ld", (long)self.messageType];
    self.textLabel.image = [UIImage imageWithUnlocalizedName:message];
    self.yesButton.image = [UIImage imageWithUnlocalizedName:@"alert_yes"];
    self.noButton.image = [UIImage imageWithUnlocalizedName:@"alert_no"];
    [self.yesButton addTarget:self onTouchUpInsideWithAction:@selector(pressYes)];
    [self.noButton addTarget:self onTouchUpInsideWithAction:@selector(pressNo)];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    } completion:^(BOOL finished) {
        self.embedView.hidden = NO;
    }];
}


- (void)pressYes {
    self.embedView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];

    [self.delegate alertView:self pressedButtonWithResponse:YES];
}


- (void)pressNo {
    self.embedView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
    [self.delegate alertView:self pressedButtonWithResponse:NO];
}

@end
