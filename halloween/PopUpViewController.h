//
//  PopUpViewController.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/12/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopUpParameters.h"

@protocol PopUpDelegate <NSObject>
- (void)close;
- (void)showPage:(NSInteger)pageToShow isPrev:(BOOL)prev;
- (void)readTheBook;

@end

@interface PopUpViewController : UIViewController
- (id)initWithPageNumber:(PopUpParameters *)param delegate:(id<PopUpDelegate>)aDeletegate;

@end
