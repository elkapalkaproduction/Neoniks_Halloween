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
    [self adjustView];
}


- (void)goToBack {
    [[SoundPlayer sharedPlayer] playClick];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)setupTargets {
    [self.arrowBackButton addTarget:self onTouchUpInsideWithAction:@selector(goToBack)];
}


- (void)adjustView {
    NSString *string = [NSString neoniksLocalizedString:@"how_to_top_fon"];
    if (isIphone5()) {
        string = [string stringByAppendingString:@"-568"];
    }
    self.backgroundImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:string ofType:@"jpg"]];
}

@end
