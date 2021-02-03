//
//  InputPasswordView.m
//  WFChatUIKit
//
//  Created by xxx on 2019/11/25.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "InputPasswordView.h"

@interface InputPasswordView ()<UITextFieldDelegate>

@end

@implementation InputPasswordView {
    NSMutableArray <UILabel*>*circles;
}
+ (InputPasswordView *)showPassword:(NSString *)type money:(NSString *)money withDelegate:(UIViewController <InputPasswordDelegate>*)delegate {
    UIView *bg = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    InputPasswordView *pwdView = [[NSBundle bundleForClass:self] loadNibNamed:@"InputPasswordView" owner:self options:nil].firstObject;
    pwdView.frame = CGRectMake(0, (gScreenHeight - 200)/2 - 100, gScreenWidth, 290);
    pwdView.typeLabel.text = type;
    pwdView.moneyLabel.text = [NSString stringWithFormat:@"¥%@",money];
    [delegate.view addSubview:bg];
    pwdView.delegate = delegate;
    [bg addSubview:pwdView];
     
    pwdView.transform = CGAffineTransformMakeScale(0.75, 0.75);
    [pwdView.pwdTextField becomeFirstResponder];
    [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [pwdView.pwdTextField becomeFirstResponder];
        pwdView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
    }];
    return pwdView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpUI];
}

- (void)dealloc {
    NSLog(@"InputPasswordView   Dealloc");
}

- (void)setUpUI {
    circles = [NSMutableArray arrayWithCapacity:6];
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.layer.cornerRadius = 8.0;
    self.pwdTextField.delegate = self;
    [self.pwdTextField addTarget:self action:@selector(textFieldChange) forControlEvents:UIControlEventEditingChanged];
    [circles addObject:self.circle1];
    [circles addObject:self.cirele2];
    [circles addObject:self.circle3];
    [circles addObject:self.cirele4];
    [circles addObject:self.circle5];
    [circles addObject:self.cirele6];
    [circles enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.cornerRadius = obj.frame.size.height/2;
        obj.layer.masksToBounds = YES;
        [obj setHidden:YES];
    }];
    [self.cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
}

- (void)textFieldChange {
    NSString *text = self.pwdTextField.text;
    if (text.length > 6) {
        return;
    }
    if (text.length >= 0) {
        [self setupCircles:text.length];
    }
    
    if (text.length == 6) {
        /// 完成
        if ([self.delegate respondsToSelector:@selector(inputDone:)]) {
            [self.delegate inputDone:text];
            [self.superview removeFromSuperview];
        }
    }
}

- (void)setupCircles:(int)index {
    [circles enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.cornerRadius = obj.frame.size.height/2;
        obj.layer.masksToBounds = YES;
        [obj setHidden:YES];
    }];
    for (int i=0; i< index; i++) {
        [circles[i] setHidden:NO];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.pwdTextField) {
        return textField.text.length < 6;
    }
    return NO;
}

- (void)cancel {
    [self.superview removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(inputCancel)]) {
        [self.delegate inputCancel];
    }
}


@end
