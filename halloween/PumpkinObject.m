//
//  PumpkinObject.m
//  halloween
//
//  Created by Andrei Vidrasco on 9/3/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "PumpkinObject.h"

@implementation PumpkinObject

- (id)initWithParameters:(NNKObjectParameters *)parameters delegate:(UIViewController<StatedObjectDelegate> *)aDelegate {
    self = [super initWithParameters:parameters delegate:aDelegate];
    
    [aDelegate fireSelector:@"sendBranchToBack:" inObjectId:self];
    
    return self;
}


- (void)pumpkinShake:(NSArray *)action {
    [self.delegate fireSelector:@"pumpkinShake:" inObjectId:self];
}


- (void)tapped:(UITapGestureRecognizer *)sender {
    [self performActions];
}

@end
