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
    CGFloat width = 91;
    CGFloat heigth = 110;
    CGFloat x;
    CGFloat y;
    NSString *doorImageName;
    switch (self.characterId) {
        case CharacterBat:
        case CharacterCat:
        case CharacterOwl:
        case CharacterSheep:
            x = 7;
            doorImageName = @"door_0";
            break;
        case CharacterKnight:
        case CharacterSnail:
        case CharacterWitch:
        case CharacterGoblin:
            doorImageName = @"door_1";
            x = 926;
            break;
        default:
            break;
    }
    switch (self.characterId) {
        case CharacterCat:
        case CharacterWitch:
            y = 172;
            break;
        case CharacterOwl:
        case CharacterKnight:
            y = 295;
            break;
        case CharacterSheep:
        case CharacterSnail:
            y = 418;
            break;
        case CharacterBat:
        case CharacterGoblin:
            y = 541;
            break;
        default:
            break;
    }
    self.view.frame = CGRectMake(x, y, width, heigth);
    self.doorImage.image = [UIImage imageNamed:doorImageName];
    if (self.questionState) {
        self.characterImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"shadow_8"]];
    } else {
        self.characterImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"shadow_%d", self.characterId]];
    }

}


- (IBAction)doorPress:(id)sender {
    [self.delegate pressDoor:self];
}


- (NSString *)nameForDoor {
    NSString *characterID;
    switch (self.characterId) {
        case CharacterBat:
            characterID = @"bat";
            break;
        case CharacterCat:
            characterID = @"cat";
            break;
        case CharacterGoblin:
            characterID = @"goblin";
            break;
        case CharacterKnight:
            characterID = @"knight";
            break;
        case CharacterOwl:
            characterID = @"owl";
            break;
        case CharacterSheep:
            characterID = @"sheep";
            break;
        case CharacterSnail:
            characterID = @"snail";
            break;
        case CharacterWitch:
            characterID = @"witch";
            break;
        default:
            break;
    }
    
    return characterID;
}

@end
