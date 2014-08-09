//
//  HowToViewController.m
//  halloween
//
//  Created by Andrei Vidrasco on 8/2/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "HowToViewController.h"
#import "Utils.h"

@interface HowToViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UIImageView *bannerImage;
@property (strong, nonatomic) IBOutlet UIImageView *textLeftImage;
@property (strong, nonatomic) IBOutlet UIImageView *textRightImage;
@property (strong, nonatomic) IBOutlet UIImageView *textCenterImage;
@property (strong, nonatomic) IBOutlet UIImageView *returnImage;
@property (strong, nonatomic) IBOutlet UIImageView *makeImage;
@property (strong, nonatomic) IBOutlet UIImageView *gameImage;
@property (strong, nonatomic) IBOutlet UIButton *arrowBackButton;

@end

@implementation HowToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTargets];
    [self updateLanguage];
    [self adjustView];
}


- (void)goToBack {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)setupTargets {
    [self.arrowBackButton addTarget:self onTouchUpInsideWithAction:@selector(goToBack)];
}


- (void)updateLanguage {
    self.bannerImage.image = [UIImage imageWithUnlocalizedName:@"how_to_banner"];
    self.textLeftImage.image = [UIImage imageWithUnlocalizedName:@"how_to_text_left"];
    self.textRightImage.image = [UIImage imageWithUnlocalizedName:@"how_to_text_right"];
    self.textCenterImage.image = [UIImage imageWithUnlocalizedName:@"how_to_text_center"];
    self.returnImage.image = [UIImage imageWithUnlocalizedName:@"how_to_return"];
    self.makeImage.image = [UIImage imageWithUnlocalizedName:@"how_to_make"];
    self.gameImage.image = [UIImage imageWithUnlocalizedName:@"how_to_new_game"];
}


- (void)adjustView {
    self.backgroundImage.image = [UIImage backgroundImageWithName:@"how_to_top_fon"];
}

@end
