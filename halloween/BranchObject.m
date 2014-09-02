//
//  BranchObject.m
//  halloween
//
//  Created by Andrei Vidrasco on 9/1/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "BranchObject.h"

@implementation BranchObject

- (id)initWithParameters:(NNKObjectParameters *)parameters delegate:(UIViewController<StatedObjectDelegate> *)aDelegate {
    self = [super initWithParameters:parameters delegate:aDelegate];
    
    [aDelegate fireSelector:@"sendBranchToBack:" inObjectId:self];
    
    return self;
}

- (void)branchFall:(NSArray *)action {
    [self.delegate fireSelector:@"branchFall:" inObjectId:self];
//    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
//    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.imageView]];
//    gravity.magnitude = 1;
//    [animator addBehavior:gravity];
}


- (void)tapped:(UITapGestureRecognizer *)sender {
    [self performActions];
}

@end
