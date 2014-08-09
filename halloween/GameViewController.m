//
//  PlayViewController.m
//  halloween
//
//  Created by Andrei Vidrasco on 8/3/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "GameViewController.h"
#import "StatedObject.h"
#import "PopUpViewController.h"
#import "PopUpAnimations.h"
#import "NNKObjectParameters.h"
#import "DoorView.h"
#import "Utils.h"

NSString *const GameDefaultObjects = @"GameDefaultObjects";
NSString *const CharacterInitialPosition = @"CharactersInitialPosition";
NSString *const GameDefaultExtension = @"plist";

@interface GameViewController () <DoorDelegate, StatedObjectDelegate, PopUpDelegate>

@property (strong, nonatomic) NSMutableArray *allObjects;
@property (strong, nonatomic) NSDictionary *characterInitialPosition;
@property (strong, nonatomic) StatedObject *currentObject;
@property (strong, nonatomic) NSMutableArray *doors;
@property (strong, nonatomic) PopUpViewController *popUpViewController;
@property (weak, nonatomic) IBOutlet UIImageView *shadowView;

@end

@implementation GameViewController

- (void)createDoorCharacterID:(Character)characterID {
    DoorView *door = [DoorView instantiateWithCharactedID:characterID delegate:self];
//    DoorView *door = [self.storyboard instantiateViewControllerWithIdentifier:@"doorView"];
//    door.characterId = characterID;
//    door.delegate = self;
    [StoryboardUtils addViewController:door onViewController:self];
    [self.doors addObject:door];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *allDictObjects = [[NSDictionary alloc] initWithContentsOfURL:[NSURL urlFromLocalizedName:GameDefaultObjects extension:GameDefaultExtension]];
    NSArray *allKeys = [allDictObjects allKeys];

    for (NSString *key in allKeys) {
        NNKObjectParameters *parameters = [[NNKObjectParameters alloc] initWithDictionary:allDictObjects[key]];
        StatedObject *object = [[StatedObject alloc] initWithParameters:parameters delegate:self];
        [self.allObjects addObject:object];
    }
    for (int i = 0; i < 8; i++) {
        [self createDoorCharacterID:i];
    }

}


- (NSMutableArray *)doors {
    if (!_doors) {
        _doors = [[NSMutableArray alloc] init];
    }
    
    return _doors;
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
    NSString *characterID = [door nameForDoor];
    NNKObjectParameters *params = [[NNKObjectParameters alloc] initWithDictionary:self.characterInitialPosition[characterID]];
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


- (void)next:(NSInteger)pageToShow isPrev:(BOOL)prev {
    [self closeWithShadow:NO];

    PopUpParameters *param = [[PopUpParameters alloc] init];
    param.isInitialView = NO;
    param.curentPage = pageToShow;
    param.fromRightToLeft = prev;
    self.popUpViewController = [[PopUpViewController alloc] initWithPageNumber:param delegate:self];
    [self.view addSubview:self.popUpViewController.view];
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


- (NSDictionary *)characterInitialPosition {
    if (!_characterInitialPosition) {
        _characterInitialPosition = [[NSDictionary alloc] initWithContentsOfURL:[NSURL urlFromLocalizedName:CharacterInitialPosition extension:GameDefaultExtension]];
    }
    
    return _characterInitialPosition;
}


- (NSMutableArray *)allObjects {
    if (!_allObjects) {
        _allObjects = [[NSMutableArray alloc] init];
    }
    
    return _allObjects;
}

@end
