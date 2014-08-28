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
#import "DoorView.h"
#import "Utils.h"

NSString *const GameDefaultObjects = @"GameDefaultObjects";
NSString *const GameDefaultExtension = @"plist";

@interface GameViewController () <DoorDelegate, StatedObjectDelegate, PopUpDelegate>

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
@property (strong, nonatomic) NNKObjectParameters *catObjectParameters;
@property (strong, nonatomic) NNKObjectParameters *owlObjectParameters;
@property (strong, nonatomic) NNKObjectParameters *sheepObjectParameters;
@property (strong, nonatomic) NNKObjectParameters *batObjectParameters;
@property (strong, nonatomic) NNKObjectParameters *witchObjectParameters;
@property (strong, nonatomic) NNKObjectParameters *knightObjectParameters;
@property (strong, nonatomic) NNKObjectParameters *snailObjectParameters;
@property (strong, nonatomic) NNKObjectParameters *goblinObjectParameters;

@end

@implementation GameViewController

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


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitialView];
    [self updateLanguage];
    [self createDoors];

}


- (NSMutableArray *)doors {
    if (!_doors) {
        _doors = [[NSMutableArray alloc] init];
    }
    
    return _doors;
}


- (IBAction)goToSite:(id)sender {
    NSURL *bookUrl = [NSURL urlForSite];
    [[UIApplication sharedApplication] openURL:bookUrl];
}


- (UIImage *)createImage {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    UIImageOrientation imageOrientation;
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            imageOrientation = UIImageOrientationRight;
            break;
        case UIInterfaceOrientationLandscapeRight:
            imageOrientation = UIImageOrientationLeft;
            break;
        case UIInterfaceOrientationPortrait:
            imageOrientation = UIImageOrientationUp;
            break;
        default:
            imageOrientation = UIImageOrientationLeft;
            break;
    }
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    return [[UIImage alloc] initWithCGImage:[img CGImage] scale:scale orientation:imageOrientation];;
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
    UIImage *image = [self createImage];
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
    NNKObjectParameters *params = [self paramsForCharacter:door.characterId];
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


- (NNKObjectParameters *)paramsForCharacter:(Character)characterID {
    switch (characterID) {
        case CharacterBat:
            return self.batObjectParameters;
            break;
        case CharacterCat:
            return self.catObjectParameters;
            break;
        case CharacterGoblin:
            return self.goblinObjectParameters;
            break;
        case CharacterKnight:
            return self.knightObjectParameters;
            break;
        case CharacterOwl:
            return self.owlObjectParameters;
            break;
        case CharacterSheep:
            return self.sheepObjectParameters;
            break;
        case CharacterSnail:
            return self.snailObjectParameters;
            break;
        case CharacterWitch:
            return self.witchObjectParameters;
            break;
    }
}


- (NNKObjectParameters *)catObjectParameters {
    if (!_catObjectParameters) {
        _catObjectParameters = [NNKObjectParameters catObjectParameters];
    }
    
    return _catObjectParameters;
}


- (NNKObjectParameters *)owlObjectParameters {
    if (!_owlObjectParameters) {
        _owlObjectParameters = [NNKObjectParameters owlObjectParameters];
    }
    
    return _owlObjectParameters;
}


- (NNKObjectParameters *)sheepObjectParameters {
    if (!_sheepObjectParameters) {
        _sheepObjectParameters = [NNKObjectParameters sheepObjectParameters];
    }
    
    return _sheepObjectParameters;
}


- (NNKObjectParameters *)batObjectParameters {
    if (!_batObjectParameters) {
        _batObjectParameters = [NNKObjectParameters batObjectParameters];
    }
    
    return _batObjectParameters;
}


- (NNKObjectParameters *)witchObjectParameters {
    if (!_witchObjectParameters) {
        _witchObjectParameters = [NNKObjectParameters witchObjectParameters];
    }
    
    return _witchObjectParameters;
}


- (NNKObjectParameters *)knightObjectParameters {
    if (!_knightObjectParameters) {
        _knightObjectParameters = [NNKObjectParameters knightObjectParameters];
    }
    
    return _knightObjectParameters;
}


- (NNKObjectParameters *)snailObjectParameters {
    if (!_snailObjectParameters) {
        _snailObjectParameters = [NNKObjectParameters snailObjectParameters];
    }
    
    return _snailObjectParameters;
}


- (NNKObjectParameters *)goblinObjectParameters {
    if (!_goblinObjectParameters) {
        _goblinObjectParameters = [NNKObjectParameters goblinObjectParameters];
    }
    
    return _goblinObjectParameters;
}


- (void)fireSelector:(SEL)selector inObjectId:(NSString *)objectId {
    
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


- (NSMutableArray *)allObjects {
    if (!_allObjects) {
        _allObjects = [[NSMutableArray alloc] init];
    }
    
    return _allObjects;
}

@end
