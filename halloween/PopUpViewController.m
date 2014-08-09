//
//  PopUpViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/12/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "PopUpViewController.h"
#import "UIButton+Helps.h"
#import "PopUpAnimations.h"
#import "Utils.h"

@interface PopUpViewController ()

@property (strong, nonatomic) IBOutlet UIButton *crossButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *popUpBackground;
@property (weak, nonatomic) IBOutlet UIImageView *popUpTitle;
@property (weak, nonatomic) IBOutlet UIImageView *textImage;
@property (weak, nonatomic) IBOutlet UIImageView *popUpArtImage;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) id <PopUpDelegate> delegate;
@property (assign, nonatomic) BOOL fromRightToLeft;
@property (assign, nonatomic) NSInteger curentPage;
@property (assign, nonatomic) BOOL isInitialView;
@property (assign, nonatomic) NSInteger nextPage;
@property (assign, nonatomic) NSInteger prevPage;

@end

@implementation PopUpViewController

#pragma mark -
#pragma mark - LifeCycle

- (id)initWithPageNumber:(PopUpParameters *)param delegate:(id<PopUpDelegate>)aDeletegate {
    if (isIphone5()) {
        self = [super initWithNibName:@"PopUpViewController5" bundle:nil];
    } else {
        self = [super initWithNibName:@"PopUpViewController" bundle:nil];
    }
    if (self) {
        _curentPage = param.curentPage;
        _fromRightToLeft = param.fromRightToLeft;
        _isInitialView = param.isInitialView;
        _delegate = aDeletegate;
    }

    return self;
}


#pragma mark -
#pragma mark - ViewCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.crossButton addTarget:self onTouchUpInsideWithAction:@selector(close)];
    if (self.isInitialView) {
        self.contentView.alpha = 0;
    } else {
        self.view.hidden = YES;
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupView];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startAnimation];
}


#pragma mark -
#pragma mark - IBActions

- (IBAction)close {
    __weak PopUpViewController *weakSelf = self;
    [PopUpAnimations animationForAppear:NO forView:self.contentView withCompletionBlock:^(BOOL finished) {
        weakSelf.view.hidden = YES;
        [weakSelf.delegate close];
    }];
}


- (IBAction)right {
    __weak PopUpViewController *weakSelf = self;
    [PopUpAnimations animationForAppear:NO fromRight:YES forView:self.contentView withCompletionBlock:^{
        weakSelf.view.hidden = YES;

        [weakSelf.delegate next:self.nextPage isPrev:NO];
    }];
}


- (IBAction)left {
    __weak PopUpViewController *weakSelf = self;
    [PopUpAnimations animationForAppear:NO fromRight:NO forView:self.contentView withCompletionBlock:^{
        weakSelf.view.hidden = YES;

        [weakSelf.delegate next:self.prevPage isPrev:YES];
    }];
}


#pragma mark -
#pragma mark - Private Methods

- (void)setupView {
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGSize screenSize = CGSizeMake(CGRectGetHeight(screenRect), CGRectGetWidth(screenRect));
    changeSize(screenSize, self.view);

    [self setupNextPages];
    [self setupImages];
    self.leftButton.hidden = self.prevPage == -1;
    self.rightButton.hidden = self.nextPage == -1;
}


- (void)setupNextPages {
    NSURL *urlForText = [NSURL urlFromLocalizedName:@"nextPages" extension:@"plist"];
    NSDictionary *allPages = [[NSDictionary alloc] initWithContentsOfURL:urlForText];
    NSString *nextPagesKey = [NSString stringWithFormat:@"%ld", (long)self.curentPage];
    NSDictionary *curentPage = allPages[nextPagesKey];
    self.nextPage = [curentPage[@"nextPage"] intValue];
    self.prevPage = [curentPage[@"previousPage"] intValue];
}


- (void)setupImages {
    NSString *popupImageName = [NSString stringWithFormat:@"%ld_popup_art", (long)self.curentPage];
    self.popUpArtImage.image = [UIImage imageWithLocalizedName:popupImageName];

    NSString *popupTitleName = [NSString stringWithFormat:@"%ld_title", (long)self.curentPage];
    self.popUpTitle.image = [UIImage imageWithUnlocalizedName:popupTitleName];

    NSString *popupTextImage = [NSString stringWithFormat:@"%ld_text", (long)self.curentPage];
    self.textImage.image = [UIImage imageWithUnlocalizedName:popupTextImage];
}


- (void)startAnimation {
    if (self.isInitialView) {
        [PopUpAnimations animationForAppear:YES forView:self.contentView withCompletionBlock:^(BOOL finished) {
            
        }];
    } else {
        [self.view setHidden:NO];
        [PopUpAnimations animationForAppear:YES fromRight:self.fromRightToLeft forView:self.contentView withCompletionBlock:^{
            
        }];
    }
}

@end
