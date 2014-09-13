//
//  NNKAlertView.h
//  halloween
//
//  Created by Andrei Vidrasco on 9/13/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NNKAlertView;

@protocol NNKAlertViewDelegate <NSObject>

- (void)alertView:(NNKAlertView *)alertView pressedButtonWithResponse:(BOOL)response;

@end

typedef NS_ENUM(NSInteger, AlertViewMessage) {
    AlertViewMessageNewGame,
    AlertViewMessageQuit,
};

@interface NNKAlertView : UIViewController

+ (instancetype)initWithMessageType:(AlertViewMessage)messageType
                     delegate:(UIViewController<NNKAlertViewDelegate> *)delegate;

@property (assign, nonatomic) AlertViewMessage messageType;

@end
