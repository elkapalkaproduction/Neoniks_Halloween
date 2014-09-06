//
//  PlayViewController.m
//  halloween
//
//  Created by Andrei Vidrasco on 8/3/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "GameViewController.h"
#import "MakeACardViewController.h"
#import "StatedObject.h"
#import "PopUpViewController.h"
#import "PopUpAnimations.h"
#import "NNKObjectParameters.h"
#import "NNKObjectParametersHelper.h"
#import "DoorView.h"
#import "Utils.h"
#import "BranchObject.h"
#import <QuartzCore/QuartzCore.h>

NSString *const GameDefaultObjects = @"GameDefaultObjects";
NSString *const GameDefaultExtension = @"plist";

@interface GameViewController () <UIDynamicAnimatorDelegate, DoorDelegate, StatedObjectDelegate, PopUpDelegate>

@property (strong, nonatomic) NSMutableArray *allObjects;
@property (strong, nonatomic) StatedObject *currentObject;
@property (strong, nonatomic) NSMutableArray *doors;
@property (strong, nonatomic) PopUpViewController *popUpViewController;
@property (weak, nonatomic) IBOutlet UIImageView *shadowView;
@property (strong, nonatomic) IBOutlet UIView *bottomMenu;
@property (strong, nonatomic) IBOutlet UIImageView *starsBackground;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UIImageView *returnImage;
@property (strong, nonatomic) IBOutlet UIImageView *makeImage;
@property (strong, nonatomic) IBOutlet UIImageView *gameImage;
@property (strong, nonatomic) IBOutlet UIButton *goToSiteButton;
@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) NNKObjectParametersHelper *parameterHelper;
@property (weak, nonatomic) IBOutlet UIView *palmZone;

@end

@implementation GameViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitialView];
    [self updateLanguage];
    [self createDoors];
}


#pragma mark - IBActions 

- (IBAction)goToSite:(id)sender {
    NSURL *bookUrl = [NSURL urlForSite];
    [[UIApplication sharedApplication] openURL:bookUrl];
}


- (void)goToMakeCard:(UIImage *)image {
    MakeACardViewController *makeCard = [MakeACardViewController instantiateWithImage:image];
    __weak GameViewController *weakSelf = self;
    [self presentViewController:makeCard animated:YES completion:^{
        for (DoorView *door in weakSelf.doors) {
            door.view.hidden = NO;
        }
        weakSelf.bottomMenu.hidden = NO;
        weakSelf.goToSiteButton.hidden = NO;
        weakSelf.currentObject.hidden = NO;
    }];
}


- (IBAction)makeSnapshot {
    for (DoorView *door in self.doors) {
        door.view.hidden = YES;
    }
    self.bottomMenu.hidden = YES;
    self.goToSiteButton.hidden = YES;
    self.currentObject.hidden = YES;
    for (StatedObject *object in self.allObjects) {
        [object stopAnimation];
    }
    UIImage *image = [UIImage createSnapshot];
    [self goToMakeCard:image];

}


- (IBAction)newGame {
    for (StatedObject *object in self.allObjects) {
        [object cleanResources];
    }
    if (self.currentObject) {
        [self.currentObject cleanResources];
    }
    [self setupInitialView];
    for (DoorView *currentDoor in self.doors) {
        currentDoor.questionState = NO;
    }
}


- (IBAction)returnToMenu:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];

}


- (void)pressDoor:(DoorView *)door {
    if ([door isQuestionState]) {
        [self showPopupWith:door.characterId];
        return;
    }
    for (DoorView *currentDoor in self.doors) {
        currentDoor.questionState = NO;
    }
    door.questionState = YES;
    if (self.currentObject) {
        [self.currentObject cleanResources];
    }
    NNKObjectParameters *params = [self.parameterHelper paramsForCharacter:door.characterId];
    self.currentObject = [[StatedObject alloc] initWithParameters:params delegate:self];
    [self.currentObject setupHighlightedImageIfExists];
}


- (void)objectInteracted:(StatedObject *)object {
    if ([self.currentObject isEqual:object]) {
        [self.allObjects addObject:self.currentObject];
        self.currentObject = nil;
        for (DoorView *currentDoor in self.doors) {
            currentDoor.questionState = NO;
        }

    }
}


- (void)showPalms:(UIGestureRecognizer *)tapGesture {
    NNKObjectParameters *params = [self.parameterHelper randomPalm];
    CGPoint locationInView = [tapGesture locationInView:self.view];
    CGSize size = params.frame.size;
    params.frame = CGRectMake(locationInView.x - size.width / 2, locationInView.y - size.height / 2, size.width, size.height);
    
    StatedObject *object = [[StatedObject alloc] initWithParameters:params delegate:self];
    [self.allObjects addObject:object];
}


#pragma mark - Custom Accesors

- (NSMutableArray *)doors {
    if (!_doors) {
        _doors = [[NSMutableArray alloc] init];
    }
    
    return _doors;
}


- (NNKObjectParametersHelper *)parameterHelper {
    return [NNKObjectParametersHelper sharedHelper];
}


- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        _animator.delegate = self;
    }
    
    return _animator;
}


- (NSMutableArray *)allObjects {
    if (!_allObjects) {
        _allObjects = [[NSMutableArray alloc] init];
    }
    
    return _allObjects;
}


#pragma mark - StatedObject Delegate

- (void)fireSelector:(NSString *)stringSelector inObjectId:(NSObject *)objectId {
    SEL selector = NSSelectorFromString(stringSelector);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:selector withObject:objectId];
#pragma clang diagnostic pop
}


#pragma mark - Private Methods

- (void)createDoorCharacterID:(Character)characterID {
    DoorView *door = [DoorView instantiateWithCharactedID:characterID delegate:self];
    [StoryboardUtils addViewController:door onViewController:self];
    [self.doors addObject:door];
}


- (void)createDoors {
    for (int i = 0; i < 8; i++) {
        [self createDoorCharacterID:i];
    }
}


- (void)setupInitialView {
    NSDictionary *allDictObjects = [[NSDictionary alloc] initWithContentsOfURL:[NSURL urlFromLocalizedName:GameDefaultObjects extension:GameDefaultExtension]];
    NSArray *allKeys = [allDictObjects allKeys];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPalms:)];
    [self.palmZone addGestureRecognizer:tapGesture];

    for (NSString *key in allKeys) {
        NNKObjectParameters *parameters = [[NNKObjectParameters alloc] initWithDictionary:allDictObjects[key]];
        StatedObject *object = [[parameters.type alloc] initWithParameters:parameters delegate:self];
        [self.allObjects addObject:object];
    }
}


- (void)updateLanguage {
    self.backgroundImage.image = [UIImage backgroundImageWithName:@"game_fon"];
    self.starsBackground.image = [UIImage backgroundImageWithName:@"make_card_fon"];
    self.goToSiteButton.image = [UIImage imageWithUnlocalizedName:@"menu_site"];
    self.returnImage.image = [UIImage imageWithUnlocalizedName:@"game_return"];
    self.makeImage.image = [UIImage imageWithUnlocalizedName:@"game_make"];
    self.gameImage.image = [UIImage imageWithUnlocalizedName:@"game_new_game"];
}


- (void)showPopupWith:(NSInteger)tag {
    [self.view bringSubviewToFront:self.shadowView];
    [PopUpAnimations animationForAppear:YES forView:self.shadowView withCompletionBlock:^(BOOL finished) {
    }];
    PopUpParameters *params = [[PopUpParameters alloc] init];
    params.fromRightToLeft = NO;
    params.curentPage = tag;
    params.isInitialView = YES;
    PopUpViewController *popUp = [[PopUpViewController alloc] initWithPageNumber:params delegate:self];
    [StoryboardUtils addViewController:popUp onViewController:self];

}


- (void)closeWithShadow:(BOOL)withShadow {
    if (withShadow) {
        [self closeAndHideShadow];
    } else {
        [self closeWithoutHidingShadow];
    }
}


- (void)close {
    [self closeWithShadow:YES];
}


- (void)showPage:(NSInteger)pageToShow isPrev:(BOOL)prev {
    [self closeWithShadow:NO];

    PopUpParameters *param = [[PopUpParameters alloc] init];
    param.isInitialView = NO;
    param.curentPage = pageToShow;
    param.fromRightToLeft = prev;
    self.popUpViewController = [[PopUpViewController alloc] initWithPageNumber:param delegate:self];
    [self.view addSubview:self.popUpViewController.view];
}


- (void)readTheBook {
    NSURL *bookUrl = [NSURL openStoreToAppWithID:bookAppID];
    [[UIApplication sharedApplication] openURL:bookUrl];
}


- (void)closeAndHideShadow {
    __weak GameViewController *weakSelf = self;
    [PopUpAnimations animationForAppear:NO forView:self.shadowView withCompletionBlock:^(BOOL finished) {
        [weakSelf.popUpViewController.view removeFromSuperview];
        weakSelf.popUpViewController = nil;
    }];
}


- (void)closeWithoutHidingShadow {

    [self.popUpViewController.view removeFromSuperview];
    self.popUpViewController = nil;
}


#pragma mark - Custom Selectors

- (void)branchFall:(UIButton *)button {
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[button]];
    gravityBehavior.magnitude = 0.6;
    [self.animator addBehavior:gravityBehavior];
    [self performSelector:@selector(recreateBranch:) withObject:button afterDelay:2.f];
}


- (void)recreateBranch:(BranchObject *)branch {
    [self.animator removeAllBehaviors];
    branch.alpha = 0.f;
    branch.transform = CGAffineTransformIdentity;
    branch.frame = branch.parameters.frame;
    [UIView animateWithDuration:0.2 animations:^{
        branch.alpha = 1.f;
    }];
}


- (void)sendBranchToBack:(NSObject *)branch {
    [self.view sendSubviewToBack:(UIView *)branch];
    [self.view sendSubviewToBack:self.starsBackground];
}


- (void)pumpkinShake:(UIButton *)button {
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:0.1];
    [shake setRepeatCount:2];
    [shake setAutoreverses:YES];
    [shake setFromValue:[NSValue valueWithCGPoint:
                         CGPointMake(button.center.x - 5, button.center.y + 5)]];
    [shake setToValue:[NSValue valueWithCGPoint:
                       CGPointMake(button.center.x + 5, button.center.y - 5)]];
    [button.layer addAnimation:shake forKey:@"position"];
}

@end
