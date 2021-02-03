//
//  TransferMoneyDetailViewController.m
//  WFChatUIKit
//
//  Created by xxx on 2019/11/20.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "TransferMoneyDetailViewController.h"
#import "SDWebImage.h"
#import "LEEAlert.h"
#import "NetworkAPI.h"
#import "MBProgressHUD.h"
#import "Predefine.h"
#import "PresentNavigationBar.h"
#import "LuckyMoneyListModel.h"
#import "LuckyManager.h"

@interface TransferMoneyDetailViewController ()

@end

@implementation TransferMoneyDetailViewController {
    LuckyMoneyListModel *_lModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PresentNavigationBar *bar = [[PresentNavigationBar alloc] init];
    [bar setLeftTitle];
    [bar.backBtn addTarget:self action:@selector(backCLick) forControlEvents:UIControlEventTouchUpInside];
    [bar.lineView setHidden:YES];
    [self.view addSubview:bar];
    [self loadData];
}

- (void)loadData {
    NSDictionary *param = @{@"redPId":self.redPId};
    [ToastManager showText:@"" inView:self.view];
    [[NetworkAPI sharedInstance] getWithUrl:MONEY_LUCKYMONEY_DETAILS params:param successComplection:^(NSDictionary * _Nonnull done) {
        self->_lModel = [LuckyMoneyListModel mj_objectWithKeyValues:done[@"data"]];
        NSInteger status = [self->_lModel.status integerValue];
        if (status == TRANSFER_NORMAL) {
            /// 未接受
            if (self.isSender) {
                /// sender
                [self initUIReceivinSender];
            } else {
                /// accepter
                [self initUIReceivinAccepter];
            }
        } else if (status == TRANSFER_HASACCEPT) {
            /// 已接受
            [self initUIAccept];
        } else if (status == TRANSFER_OUTOFTIME) {
            /// 已过期
            [self initUIOutOfTime];
            [LuckyManager updateTransferMessageHasOutofTime:self.message];
        }
    } failureComplection:^(NSDictionary * _Nonnull done) {
        [ToastManager showToast:done[@"msg"] inView:self.view];
    }];
}

/// 确定
- (void)sureBtnCLick{
    NSDictionary *param = @{@"userId":self.userId,@"redPId":self.redPId};
    [ToastManager showText:@"" inView:self.view];
    [[NetworkAPI sharedInstance] postWithUrl:MONEY_TRANSFER_ACCEPT params:param successComplection:^(NSDictionary * _Nonnull done) {
        [ToastManager showToast:@"接收成功" inView:self.view];
        if (self.accept) {
            self.accept();
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } failureComplection:^(NSDictionary * _Nonnull done) {
        [ToastManager showToast:done[@"msg"] inView:self.view];
    }];
}

/// 还未被领取--接收者
- (void)initUIReceivinAccepter {
    CGFloat kWidth = self.view.frame.size.width;
    CGFloat kheight = self.view.frame.size.height;
    
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:237/255.0 blue:238/255.0 alpha:1];
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth - 50)/2, 30 + kStatusBarAndNavigationBarHeight, 50, 50)];
    iconImage.image = [UIImage imageNamed:@"wxp_transfer_status_receiving"];
    
    UILabel *nameLabel  = [[UILabel alloc] initWithFrame:CGRectMake((kWidth - 150)/2, CGRectGetMaxY(iconImage.frame) + 30, 150, 20)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.text = [NSString stringWithFormat:@"待%@确认收款",_lModel.name];
    
    
    UILabel *yuanLabel  = [[UILabel alloc] initWithFrame:CGRectMake((kWidth - 150)/2, CGRectGetMaxY(nameLabel.frame) + 10, 150, 40)];
    yuanLabel.textAlignment = NSTextAlignmentCenter;
    yuanLabel.text =  [_lModel getMoneyStr];
    yuanLabel.font = WechatFont(40);
    
    UILabel *startLabel  = [[UILabel alloc] initWithFrame:CGRectMake(20, kheight - kTabbarSafeBottomMargin - 80, kWidth - 40, 15)];
    startLabel.textAlignment = NSTextAlignmentCenter;
    startLabel.font = [UIFont systemFontOfSize:11];
    startLabel.textColor = [UIColor grayColor];
    startLabel.text = [NSString stringWithFormat:@"转账时间：%@", _lModel.createdAt];
    
    
    [self.view addSubview:iconImage];
    [self.view addSubview:nameLabel];
    [self.view addSubview:yuanLabel];
    [self.view addSubview:startLabel];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake((gScreenWidth - 200)/2, CGRectGetMaxY(yuanLabel.frame) + 200, 200, 50)];
    [sureBtn setBackgroundColor: HEXCOLOR(0x56BE6A)];

    [sureBtn addTarget:self action:@selector(sureBtnCLick) forControlEvents:UIControlEventTouchDown];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 5.f;
    [sureBtn setTitle:@"确认收款" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    
    
    UILabel *hintLabel  = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(sureBtn.frame) + 20, kWidth - 40, 15)];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.font = [UIFont systemFontOfSize:13];
    hintLabel.textColor = [UIColor grayColor];
    hintLabel.text = [NSString stringWithFormat:@"1天未确认，将退还给对方"];
    [self.view addSubview:sureBtn];
    [self.view addSubview:hintLabel];
}
/// 还未被领取--发送者
- (void)initUIReceivinSender {
    CGFloat kWidth = self.view.frame.size.width;
    CGFloat kheight = self.view.frame.size.height;
    
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:237/255.0 blue:238/255.0 alpha:1];
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth - 50)/2, 30 + kStatusBarAndNavigationBarHeight, 50, 50)];
    iconImage.image = [UIImage imageNamed:@"wxp_transfer_status_receiving"];
    
    UILabel *nameLabel  = [[UILabel alloc] initWithFrame:CGRectMake((kWidth - 150)/2, CGRectGetMaxY(iconImage.frame) + 30, 150, 20)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.text = [NSString stringWithFormat:@"待确认收款"];
    
    
    UILabel *yuanLabel  = [[UILabel alloc] initWithFrame:CGRectMake((kWidth - 300)/2, CGRectGetMaxY(nameLabel.frame) + 10, 300, 40)];
    yuanLabel.textAlignment = NSTextAlignmentCenter;
    yuanLabel.text = [_lModel getMoneyStr];
    yuanLabel.font = WechatFont(40);
    
    UILabel *startLabel  = [[UILabel alloc] initWithFrame:CGRectMake(20, kheight - kTabbarSafeBottomMargin - 80, kWidth - 40, 15)];
    startLabel.textAlignment = NSTextAlignmentCenter;
    startLabel.font = [UIFont systemFontOfSize:11];
    startLabel.textColor = [UIColor grayColor];
    startLabel.text = [NSString stringWithFormat:@"转账时间：%@", _lModel.createdAt];
    
    
    [self.view addSubview:iconImage];
    [self.view addSubview:nameLabel];
    [self.view addSubview:yuanLabel];
    [self.view addSubview:startLabel];
    
    
    UILabel *hintLabel  = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(yuanLabel.frame) + 20, kWidth - 40, 15)];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.font = [UIFont systemFontOfSize:13];
    hintLabel.textColor = [UIColor grayColor];
    hintLabel.text = [NSString stringWithFormat:@"1天内朋友未确认，将退还给你"];
    [self.view addSubview:hintLabel];
}
/// 超期未被领取
- (void)initUIOutOfTime {
//
    CGFloat kWidth = self.view.frame.size.width;
    CGFloat kheight = self.view.frame.size.height;
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:237/255.0 blue:238/255.0 alpha:1];
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth - 50)/2, 30 + kStatusBarAndNavigationBarHeight, 50, 50)];
    iconImage.image = [UIImage imageNamed:@"wxp_transfer_status_delay_wait"];
    
    UILabel *nameLabel  = [[UILabel alloc] initWithFrame:CGRectMake((kWidth - 150)/2, CGRectGetMaxY(iconImage.frame) + 30, 150, 20)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.text = [NSString stringWithFormat:@"超时未领取"];
    
    
    UILabel *yuanLabel  = [[UILabel alloc] initWithFrame:CGRectMake((kWidth - 150)/2, CGRectGetMaxY(nameLabel.frame) + 10, 150, 40)];
    yuanLabel.textAlignment = NSTextAlignmentCenter;
    yuanLabel.text = [_lModel getMoneyStr];
    yuanLabel.font = WechatFont(40);
    
    UILabel *startLabel  = [[UILabel alloc] initWithFrame:CGRectMake(20, kheight - kTabbarSafeBottomMargin - 80, kWidth - 40, 15)];
    startLabel.textAlignment = NSTextAlignmentCenter;
    startLabel.font = [UIFont systemFontOfSize:11];
    startLabel.textColor = [UIColor grayColor];
    startLabel.text = [NSString stringWithFormat:@"转账时间：%@", _lModel.createdAt];
    
    [self.view addSubview:iconImage];
    [self.view addSubview:nameLabel];
    [self.view addSubview:yuanLabel];
    [self.view addSubview:startLabel];
    
    MessageContentModel *extModel = [MessageContentModel findMessage:self.message.messageUid];
    if (!extModel) {
        extModel = [MessageContentModel messageWithJson:self.message.content.extra];
        extModel.status = TRANSFER_OUTOFTIME;
        [MessageContentModel insertMessage:extModel];
    }
    
}
/// 已经领取了
- (void)initUIAccept {
    CGFloat kWidth = self.view.frame.size.width;
    CGFloat kheight = self.view.frame.size.height;
    
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:237/255.0 blue:238/255.0 alpha:1];
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth - 50)/2, 30 + kStatusBarAndNavigationBarHeight, 50, 50)];
    iconImage.image = [UIImage imageNamed:@"wxp_charge_success"];
    
    UILabel *nameLabel  = [[UILabel alloc] initWithFrame:CGRectMake((kWidth - 150)/2, CGRectGetMaxY(iconImage.frame) + 30, 150, 20)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.text = [NSString stringWithFormat:@"%@已收款",_lModel.name];
    
    
    
    UILabel *yuanLabel  = [[UILabel alloc] initWithFrame:CGRectMake((kWidth - 150)/2, CGRectGetMaxY(nameLabel.frame) + 10, 150, 40)];
    yuanLabel.textAlignment = NSTextAlignmentCenter;
    yuanLabel.text = [_lModel getMoneyStr];
    yuanLabel.font = WechatFont(40);
    
    
    UILabel *startLabel  = [[UILabel alloc] initWithFrame:CGRectMake(20, kheight - kTabbarSafeBottomMargin - 80, kWidth - 40, 15)];
    startLabel.textAlignment = NSTextAlignmentCenter;
    startLabel.font = [UIFont systemFontOfSize:11];
    startLabel.textColor = [UIColor grayColor];
    startLabel.text = [NSString stringWithFormat:@"转账时间：%@", _lModel.createdAt];
    
    UILabel *endLabel  = [[UILabel alloc] initWithFrame:CGRectMake(20, kheight - kTabbarSafeBottomMargin - 65, kWidth - 40, 15)];
    endLabel.textAlignment = NSTextAlignmentCenter;
    endLabel.font = [UIFont systemFontOfSize:11];
    endLabel.textColor = [UIColor grayColor];
    endLabel.text = [NSString stringWithFormat:@"接收时间：%@", _lModel.updatedAt];
    
    [self.view addSubview:iconImage];
    [self.view addSubview:nameLabel];
    [self.view addSubview:yuanLabel];
    [self.view addSubview:startLabel];
    [self.view addSubview:endLabel];
}


- (void)writeNote{
    
}

@end
