//
//  DoorView.m
//  halloween
//
//  Created by Andrei Vidrasco on 8/5/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "DoorView.h"
#import "Utils.h"

@interface DoorView ()

@property (strong, nonatomic) IBOutlet UIImageView *doorImage;
@property (strong, nonatomic) IBOutlet UIButton *characterImage;
@property (weak, nonatomic) id<DoorDelegate> delegate;
@property (assign, nonatomic) Character characterId;

@end

@implementation DoorView

+ (instancetype)instantiateWithCharactedID:(Character)characterID delegate:(UIViewController<DoorDelegate> *)delegate {
    DoorView *door = [delegate.storyboard instantiateViewControllerWithIdentifier:@"doorView"];
    door.characterId = characterID;
    door.delegate = delegate;
    
    return door;
}


- (void)setCharacterId:(Character)charactedId {
    _characterId = charactedId;
    [self updateImages];
}


- (void)setQuestionState:(BOOL)questionState {
    _questionState = questionState;
    [self updateImages];
}


- (void)updateImages {
    CGFloat width = [self getDeviceValueFromIphone4:40 iphone5:40 ipad:91];
    CGFloat heigth = [self getDeviceValueFromIphone4:48 iphone5:48 ipad:110];
    CGFloat x;
    CGFloat y;
    NSString *doorImageName;
    switch (self.characterId) {
        case CharacterBat:
        case CharacterCat:
        case CharacterOwl:
        case CharacterSheep:
            x = [self getDeviceValueFromIphone4:1 iphone5:4 ipad:7];
            doorImageName = @"door_0";
            break;
        case CharacterKnight:
        case CharacterSnail:
        case CharacterWitch:
        case CharacterGoblin:
            doorImageName = @"door_1";
            x = [self getDeviceValueFromIphone4:439 iphone5:525 ipad:926];
            break;
        default:
            break;
    }
    switch (self.characterId) {
        case CharacterCat:
        case CharacterWitch:
            y = [self getDeviceValueFromIphone4:74 iphone5:74 ipad:172];
            break;
        case CharacterOwl:
        case CharacterKnight:
            y = [self getDeviceValueFromIphone4:126 iphone5:126 ipad:295];
            break;
        case CharacterSheep:
        case CharacterSnail:
            y = [self getDeviceValueFromIphone4:178 iphone5:178 ipad:418];
            break;
        case CharacterBat:
        case CharacterGoblin:
            y = [self getDeviceValueFromIphone4:230 iphone5:230 ipad:541];;
            break;
        default:
            break;
    }
    if (self.characterId == CharacterGoblin && !self.questionState) {
        heigth = width * 382 / 182;
    }
    
    self.view.frame = CGRectMake(x, y, width, heigth);
    self.doorImage.image = [UIImage imageNamed:doorImageName];
    if (self.questionState) {
        self.characterImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"shadow_8"]];
    } else {
        self.characterImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"shadow_%ld", self.characterId]];
    }

}


- (IBAction)doorPress:(id)sender {
    [self.delegate pressDoor:self];
}


- (CGFloat)getDeviceValueFromIphone4:(CGFloat)iphone4 iphone5:(CGFloat)iphone5 ipad:(CGFloat)ipad {
    return isIphone()? isIphone5()? iphone5 : iphone4 : ipad;
}

@end
