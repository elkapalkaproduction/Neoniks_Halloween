//
//  NNKObjectParametersHelper.m
//  halloween
//
//  Created by Andrei Vidrasco on 9/3/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "NNKObjectParametersHelper.h"

@interface NNKObjectParametersHelper ()

@property (strong, nonatomic) NNKObjectParameters *catObjectParameters;
@property (strong, nonatomic) NNKObjectParameters *owlObjectParameters;
@property (strong, nonatomic) NNKObjectParameters *sheepObjectParameters;
@property (strong, nonatomic) NNKObjectParameters *batObjectParameters;
@property (strong, nonatomic) NNKObjectParameters *witchObjectParameters;
@property (strong, nonatomic) NNKObjectParameters *knightObjectParameters;
@property (strong, nonatomic) NNKObjectParameters *snailObjectParameters;
@property (strong, nonatomic) NNKObjectParameters *goblinObjectParameters;

@end

@implementation NNKObjectParametersHelper

+ (instancetype)sharedHelper {
    static NNKObjectParametersHelper *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
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

@end
