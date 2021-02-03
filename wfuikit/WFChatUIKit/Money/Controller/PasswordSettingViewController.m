//
//  PasswordSettingViewController.m
//  WFChatUIKit
//
//  Created by shangguan on 2019/11/26.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "PasswordSettingViewController.h"
#import "XMPayCodeView.h"
#import "NetworkAPI.h"
#import "CreateWalletModel.h"
#import <WFChatClient/WFCChatClient.h>
#import "UserInfo.h"

@interface PasswordSettingViewController ()
/// 支付密码输入框
@property (weak, nonatomic) XMPayCodeView *payCodeView;

@end

@implementation PasswordSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *tipL = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 30)];
    if (self.isMakeSure) {
        tipL.text = @"再次确认密码";
    } else {
        tipL.text = @"设定密码";
    }
    self.title = @"创建钱包";
    tipL.textAlignment = NSTextAlignmentCenter;
    tipL.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:tipL];
    // 支付密码输入框
    XMPayCodeView *payCodeView = [[XMPayCodeView alloc]initWithFrame:CGRectMake(0, 180, self.view.bounds.size.width, 60)];
    [self.view addSubview:payCodeView];
    // 1.暗文输入，自动验证
    payCodeView.secureTextEntry = YES;  // 设置暗文
    payCodeView.endEditingOnFinished = YES;  // 完成输入，退出键盘
    // 回调
    __weak typeof(self) weakSelf = self;
    [payCodeView setPayBlock:^(NSString *payCode) {
        if (weakSelf.isMakeSure == NO) {
            /// 再次确认页面
            PasswordSettingViewController *pv = [[PasswordSettingViewController alloc] init];
            pv.isMakeSure = YES;
            pv.firstPassword = payCode;
            pv.userId = weakSelf.userId;
            [weakSelf.navigationController pushViewController:pv animated:YES];
        } else {
            /// 再次确认之后需要进行第二次验证
            if ([payCode isEqualToString:weakSelf.firstPassword]) {
                [weakSelf createWallet:payCode];
            } else {
                [ToastManager showToast:@"前后设置密码不一样" inView:self.view];
                [weakSelf.payCodeView becomeKeyBoardFirstResponder];
            }
        }
    }];
    // 1秒后，让密码输入成为第一响应
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [payCodeView becomeKeyBoardFirstResponder];
    });
}

- (void)createWallet:(NSString *)paycode{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"payNumber"] = paycode;
    param[@"userId"] = self.userId;
    [ToastManager showText:@"" inView:self.view];
    [[NetworkAPI sharedInstance] postWithUrl:WALLET_CREATE params:param successComplection:^(NSDictionary * _Nonnull done) {
        [UserInfo sharedInstance].money = [NSString stringWithFormat:@"%@",done[@"data"][@"money"]];
        [UserInfo sharedInstance].hasWallet = YES;
        [ToastManager showToast:@"创建成功" inView:self.view];
    } failureComplection:^(NSDictionary * _Nonnull done) {
        [ToastManager showToast:done[@"msg"] inView:self.view];
    }];
}

- (void)getWallet {
    
}


@end
