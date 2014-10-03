//
//  NNKParentAlertView.m
//
//  Created by Vidrasco Andrei on 23/8/14.
//  Copyright (c) 2012 Neoniks. All rights reserved.
//

#import "NNKParentAlertView.h"
#import "Utils.h"

@interface NNKParentAlertView ()

@property (strong, nonatomic) ActionBlock completionBlock;
@property (strong, nonatomic) IBOutlet UIButton *alertCancel;
@property (strong, nonatomic) IBOutlet UIButton *alertAction;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *alertDetailText;
@property (strong, nonatomic) IBOutlet UILabel *alertText;
@property (strong, nonatomic) IBOutlet UIView *customPop;

@end

@implementation NNKParentAlertView

- (instancetype)initCustomPopWithFrame:(CGRect)frame
                       completionBlock:(ActionBlock)completionBlock {
    self = (NNKParentAlertView *)[[UINib nibWithNibName:@"NNKParentAlertView" bundle:nil]
                               instantiateWithOwner:self options:nil][0];
    if (self) {
        self.frame = frame;
        _completionBlock = completionBlock;
        NSDictionary *growup = [self growup];
        [_alertAction setTag:[growup[@"numberKey"] integerValue]];
        [_alertAction addTarget:self action:@selector(okPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_alertCancel addTarget:self action:@selector(removeCustomPop:) forControlEvents:UIControlEventTouchUpInside];
        [_textField becomeFirstResponder];
        _alertText.text = growup[@"title"];
        _alertDetailText.text = growup[@"number"];
        [_alertCancel setTitle:growup[@"cancelButton"] forState:UIControlStateNormal];
        [_alertAction setTitle:growup[@"okButton"] forState:UIControlStateNormal];
    }

    return self;
}


- (void)showInView:(UIView *)view {
    CAKeyframeAnimation *popInAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];

    popInAnimation.duration = 0.25;
    popInAnimation.values = @[@0.6f, @1.1f, @.9f, @1.0f];
    popInAnimation.keyTimes = @[@0.0f, @0.6f, @0.8f, @1.0f];

    [self.customPop.layer addAnimation:popInAnimation forKey:@"transform.scale"];
    [UIView commitAnimations];
    [view addSubview:self];
}


- (NSDictionary *)growup {
    NSDictionary *numbersDict;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (isRussian()) {
        numbersDict = @{@"Две тысячи пятьсот пятьдесят два" : @2552,
                        @"Пять тысяч семьсот двадцать пять" : @5725,
                        @"Семь тысяч сто восемьдесят два" : @7182};
        
        dict[@"title"] = @"Только для родителей!\nВведи номер цифрами:";
        dict[@"okButton"] = @"Проверить";
        dict[@"cancelButton"] = @"Отмена";

    } else {
        numbersDict = @{@"Two Thousand Five Hundred Fifty-Two" : @2552,
                        @"Five Thousand Seven Hundred Twenty-Five" : @5725,
                        @"Seven Thousand One Hundred Eighty-Two" : @7182};
        
        dict[@"title"] = @"Grown-ups Only!\nEnter this number numerically:";
        dict[@"okButton"] = @"OK";
        dict[@"cancelButton"] = @"Cancel";
    }
    
    NSInteger i = arc4random() % 3;
    NSArray *numbers = [numbersDict allKeys];
    dict[@"number"] = numbers[i];
    dict[@"numberKey"] = numbersDict[numbers[i]];

    return dict;
}


- (IBAction)removeCustomPop:(id)sender {
    [self removeFromSuperview];
}


- (IBAction)okPressed:(id)sender {
    [self removeCustomPop:sender];

    if ([sender tag] == [self.textField.text integerValue]) {
        self.completionBlock();
    } else {
        NSString *title;
        NSString *message;
        if (!isRussian()) {
            title = @"Sorry!";
            message = @"Incorrect number, please try again!";
        } else {
            title = @"Неправильный номер";
            message = @"Попробуйте еще раз!";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

@end
