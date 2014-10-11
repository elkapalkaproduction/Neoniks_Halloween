//
//  HalloweenBaseViewController.m
//  halloween
//
//  Created by Andrei Vidrasco on 10/11/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "HalloweenBaseViewController.h"
#import "AdsManager.h"

@interface HalloweenBaseViewController ()

@end

@implementation HalloweenBaseViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[AdsManager sharedManager] startLogTime:[NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"ViewController" withString:@""]];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[AdsManager sharedManager] endLogTime];
}


@end
