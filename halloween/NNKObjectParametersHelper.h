//
//  NNKObjectParametersHelper.h
//  halloween
//
//  Created by Andrei Vidrasco on 9/3/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "NNKObjectParameters.h"
#import "DoorView.h"

@interface NNKObjectParametersHelper : NSObject

+ (instancetype)sharedHelper;
- (NNKObjectParameters *)paramsForCharacter:(Character)characterID;
- (NNKObjectParameters *)randomPalm;

@end
