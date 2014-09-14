//
//  ViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/11/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "LogoViewController.h"
#import "UIImage+Helps.h"
#import "StoryboardUtils.h"

NSString *const storyboardId = @"menuViewController";

@interface LogoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@end

@implementation LogoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateImages];
    [self shortAnimation];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


- (void)updateImages {
    [self.logoImage setImage:[UIImage imageWithUnlocalizedName:@"logo"]];
}


- (void)shortAnimation {
    float timeInterval = 1.f;
    [UIView animateWithDuration:timeInterval delay:timeInterval options:UIViewAnimationOptionCurveEaseIn animations:^{
         self.logoImage.alpha = 1.f;
     } completion:^(BOOL finished) {
         [UIView animateWithDuration:timeInterval delay:timeInterval options:UIViewAnimationOptionCurveEaseIn animations:^{
             self.logoImage.alpha = 0.f;
         } completion:^(BOOL finished) {
             [StoryboardUtils presentViewControllerWithStoryboardID:storyboardId fromViewController:self];
         }];
     }];
}

@end
