//
//  DoorView.h
//  halloween
//
//  Created by Andrei Vidrasco on 8/5/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, Character) {
    CharacterCat,
    CharacterOwl,
    CharacterSheep,
    CharacterBat,
    CharacterWitch,
    CharacterKnight,
    CharacterSnail,
    CharacterGoblin,
};
@class DoorView;

@protocol DoorDelegate <NSObject>

- (void)pressDoor:(DoorView *)door;

@end

@interface DoorView : UIViewController

+ (instancetype)instantiateWithCharactedID:(Character)characterID delegate:(UIViewController<DoorDelegate> *)delegate;

@property (assign, nonatomic, readonly) Character characterId;

@property (assign, nonatomic, getter = isQuestionState) BOOL questionState;

@end
