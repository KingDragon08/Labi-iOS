//
//  BonusViewController.m
//  WildFireChat
//
//  Created by xxx on 2018/12/12.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "BonusViewController.h"
#import "BindCardViewController.h"

@interface BonusViewController ()
@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UILabel *inputHitLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTopLayout;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation BonusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputHitLabel.hidden = YES;
    if (self.type == KTiXian) {
        self.inputHitLabel.text = LocalizedString(@"InputMoney");
    } else {
        self.inputHitLabel.text = LocalizedString(@"Inputintegral");
    }
    [self.sureBtn setTitle: LocalizedString(@"Ok") forState:UIControlStateNormal];
}
- (IBAction)sureClick:(id)sender {
    if (self.field.text.length <= 0) {
        return;
    }
    
    if (self.type == KTiXian) {
        [self func2];
        self.selectView.hidden = NO;
    } else {
        [self func1];
        self.selectView.hidden = YES;
    }
    
}
- (IBAction)selectMoneyClick:(id)sender {
    NSInteger tag = [(UIView *)sender tag];
    self.field.text = [NSString stringWithFormat:@"%ld", tag * 50];
}

- (void)func1 {
    NSString *sn = [WFCCNetworkService sharedInstance].userId;
    NSDictionary *param = @{@"userId": sn, @"bonus":self.field.text};
    [[NetworkAPI sharedInstance] v2GetWithUrl:APP_bonus2Jifen params:param successComplection:^(NSDictionary * _Nonnull done) {
        [ToastManager showToast:@"Success" inView:self.view];
    } failureComplection:^(NSDictionary * _Nonnull done) {
        [ToastManager showToast:done[@"msg"] inView:self.view];
    }];
}

- (void)func2 {
    NSString *sn = [WFCCNetworkService sharedInstance].userId;
    NSDictionary *param = @{@"userId": sn, @"amount":self.field.text};
    [[NetworkAPI sharedInstance] v2GetWithUrl:APP_excharge params:param successComplection:^(NSDictionary * _Nonnull done) {
        [ToastManager showToast:@"Success" inView:self.view];
    } failureComplection:^(NSDictionary * _Nonnull done) {
        [ToastManager showToast:done[@"msg"] inView:self.view];
    }];
}


@end
