//
//  OpenLuckMoneyView.m
//  ShowAnimation
//
//  Created by shangguan on 2019/11/21.
//  Copyright © 2019 shangguan. All rights reserved.
//

#import "OpenLuckMoneyView.h"
#import "Predefine.h"
#import "MessageContentModel.h"
#import "RobLuckyMoneyManager.h"
#import "SDWebImage.h"
#import "LuckyMoneyDetailViewController.h"

@interface OpenLuckMoneyView () <CAAnimationDelegate>

@property (nonatomic, strong) UIView *luckyMoney;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *detailBtn;
@property (nonatomic, strong) UIButton *openBtn;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *noteLabel;

@property (nonatomic, strong) UIImageView *topRedbg;
@property (nonatomic, strong) UIImageView *bottomRedbg;

@property (nonatomic, strong) UIImageView *roateImage;
@property (nonatomic, strong) WFCCMessage *message;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *redPId;

@property (nonatomic, strong) LuckyManager *lManager;

@end
@implementation OpenLuckMoneyView {
    UITapGestureRecognizer *_closeTap;
    LuckyMoneyListModel *allRecordsModel;
}

- (instancetype) initWithMessage:(WFCCMessage *) message status:(NSInteger)status {
    if (self = [super init]) {
        self.message = message;
        self.status = status;
        [self initUI];
    }
    return self;
}

+ (OpenLuckMoneyView *)showBgWithMessage:(WFCCMessage *)message status:(NSInteger)status {
    OpenLuckMoneyView *o = [[OpenLuckMoneyView alloc] initWithMessage:message status:status];
    [o showBg];
    return o;
}

- (void)initUI {
    CGRect bFrame = [UIScreen mainScreen].bounds;
    self.frame = bFrame;
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    self.closeBtn = [[UIButton alloc] init];
    [self.closeBtn setImage:[UIImage imageNamed:@"HongBao_Close_Image"] forState:UIControlStateNormal];
    [self.closeBtn setImage:[UIImage imageNamed:@"HongBao_Close_Image"] forState:UIControlStateHighlighted];
    [self.closeBtn addTarget:self action:@selector(hiddenSelf) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat sWidth = bFrame.size.width;
    CGFloat mWidth = 290;
    CGFloat mHeight = 480;
    UIView *redBg = [[UIView alloc] initWithFrame:CGRectMake((sWidth - mWidth)/2, kStatusBarAndNavigationBarHeight + 20, mWidth, mHeight)];
    redBg.layer.cornerRadius = 6.0;
    redBg.layer.masksToBounds = YES;
    
    [self addSubview:redBg];
    self.luckyMoney = redBg;
    [self addSubview:self.closeBtn];
    self.closeBtn.frame = CGRectMake((sWidth - 48)/2, CGRectGetMaxY(redBg.frame) + 20, 48, 48);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelf)];
    [self addGestureRecognizer:tap];
    [self luckyMoneyAddSubs];
    _closeTap = tap;
}

- (void)luckyMoneyAddSubs{
    CGFloat mWidth = self.luckyMoney.frame.size.width;
    CGFloat mHeight = self.luckyMoney.frame.size.height;
    self.topRedbg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RedEnvelope_Bg"]];
    self.topRedbg.frame = CGRectMake(0, 0, mWidth, 388);
    
    UIImage *sImage = [UIImage imageNamed:@"LuckyMoney_PocketUnderBg_Bottom"];
    self.bottomRedbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 385-45, mWidth, 45 + 95)];
    self.bottomRedbg.image = sImage;
    
    [self.luckyMoney addSubview:self.topRedbg];
    [self.luckyMoney addSubview:self.bottomRedbg];
    self.detailBtn = [[UIButton alloc] initWithFrame:CGRectMake((mWidth - 100)/2, mHeight - 30, 120, 20)];
    [self.detailBtn setTitle:@"查看领取详情" forState:UIControlStateNormal];
    self.detailBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    self.detailBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 90, 0, 0);
    [self.detailBtn setImage:[UIImage imageNamed:@"LuckyMoney_YelllowArrow"] forState:UIControlStateNormal];
    [self.detailBtn setImage:[UIImage imageNamed:@"LuckyMoney_YelllowArrow"] forState:UIControlStateHighlighted];
    [self.detailBtn setTitleColor:LUCKMONEY_TITLE_COLOR forState:UIControlStateNormal];
    self.detailBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [self.detailBtn addTarget:self action:@selector(detailBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    [self.luckyMoney addSubview:self.detailBtn];
    
    
    self.nameLabel = [[UILabel alloc] init];
    
    WFCCUserInfo *user = [[WFCCIMService sharedWFCIMService] getUserInfo:self.message.fromUser refresh:NO];
    MessageContentModel *cModel = [MessageContentModel messageWithJson:self.message.content.extra];
    self.redPId = cModel.redPId;
    NSString *titleStr = [NSString stringWithFormat:@"%@的红包",user.name];
    [self.nameLabel setText:titleStr];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.nameLabel.textColor = LUCKMONEY_TITLE_COLOR;
    [self.topRedbg addSubview:self.nameLabel];
    self.nameLabel.frame = CGRectMake(0, 0, 240, 30);
    [self.nameLabel sizeToFit];
    [self.nameLabel setCenter:CGPointMake(mWidth/2+15, 105)];
    
    
    UIImageView *headerIcon = [[UIImageView alloc] init];
    headerIcon.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame) - 25, 95, 20, 20);
    headerIcon.layer.masksToBounds = YES;
    headerIcon.layer.cornerRadius = 3.0;
    headerIcon.backgroundColor = [UIColor whiteColor];
    [self.topRedbg addSubview:headerIcon];
    [headerIcon sd_setImageWithURL:[NSURL URLWithString:user.portrait] placeholderImage:[UIImage imageNamed:@"PersonalChat"]];
    
    self.noteLabel = [[UILabel alloc] init];
    self.noteLabel.text = cModel.note;
    self.noteLabel.font = [UIFont systemFontOfSize:20];
    self.noteLabel.adjustsFontSizeToFitWidth = true;
    self.noteLabel.textColor = LUCKMONEY_TITLE_COLOR;
    self.noteLabel.textAlignment = NSTextAlignmentCenter;
    self.noteLabel.frame = CGRectMake(5, CGRectGetMaxY(self.nameLabel.frame) + 20, mWidth-10, 46);
    self.noteLabel.numberOfLines = 0;
    [self.topRedbg addSubview:self.noteLabel];
    
    self.openBtn = [[UIButton alloc] initWithFrame:CGRectMake((mWidth - 90)/2,385-45 , 90, 90)];
    [self.openBtn addTarget:self action:@selector(openHongbao) forControlEvents:UIControlEventTouchUpInside];
    [self.luckyMoney addSubview:self.openBtn];
    self.roateImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LuckyMoney_RoundBtn"]];
    self.roateImage.frame = self.openBtn.bounds;
    [self.openBtn addSubview:self.roateImage];
    [self setData];
}
// MARK: 根据数据进行显示不同状态下的UI
- (void)setData {
    MessageContentModel *model = [MessageContentModel findMessage:self.message.messageUid];
    if (model == nil) {
        self.status = 0;
    } else {
        self.status = model.status;
    }
    
    /// 当前用户已经抢过了，再次进入
    if (self.status == 0) {
        /// 当前可以抢，还没有点击过
        [self.openBtn setHidden:NO];
    } else if (self.status == 1) {
        /// 已经抢过了，没抢到
        self.noteLabel.text = @"手慢了，红包派完了";
        [self.openBtn setHidden:YES];
    } else if (self.status == 2) {
        /// 没有来得及抢，已经过期了
        self.noteLabel.text = @"该红包已经超过24小时。如已领取，可在“红包记录”中查看";
        [self.openBtn setHidden:YES];
    } else if (self.status == 10) {
        /// 本人已经抢到了,本地保存的状态
        self.noteLabel.text = [NSString stringWithFormat:@"￥%@",[model moneyYuan]];
        self.noteLabel.font = WechatFont(40);
        [self.openBtn setHidden:YES];
    }
    [self showBg];
}
/// 开红包动画
- (void)openHongbao{
    [self layerRotation];
    [self robLuckyMoney];
}

- (void)detailBtnCLick {
    LuckyMoneyDetailViewController *lvc = [[LuckyMoneyDetailViewController alloc] init];
    lvc.redPId = self.redPId;
    lvc.isGroup = NO;
    lvc.conversationId = self.message.conversation.target;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self removeFromSuperview];
    });
    [self.lManager.vc.navigationController pushViewController:lvc animated:YES];
}
// MARK: 抢～
- (void)robLuckyMoney {
    NSString *userId = [[WFCCNetworkService sharedInstance] userId];
    NSDictionary *param = @{@"userId":userId,@"redPId":self.redPId};
    
    [[NetworkAPI sharedInstance] postWithUrl:MONEY_LUCKYMONEY_ROB params:param successComplection:^(NSDictionary * _Nonnull done) {
        
        self->allRecordsModel = [LuckyMoneyListModel mj_objectWithKeyValues:done[@"data"]];
        MoneyRecordModel *record = self->allRecordsModel.mineRecord;
        self.status = [[NSString stringWithFormat:@"%@",done[@"data"][@"status"]] integerValue];
        if (record == nil) {
            [self.lManager single_updateMessage:self.message status:self.status];
        } else {
            MessageContentModel *mContent = [MessageContentModel messageWithJson:self.message.content.extra];
            mContent.money = [NSString stringWithFormat:@"%ld", record.money];
            self.message.content.extra = [mContent jsonWithMessage];
            /// 本人已经领取了 10 -本人已经领取了
            /// 单人已经领取成功，则需要发送已经领取的红包消息
            [self.lManager single_updateMessage:self.message status:MONEY_STATE_HAS_ROBED];
            [self.lManager single_insertAcceptMessage:self.message status:MONEY_STATE_HAS_ROBED];
        }
        [self performSelector:@selector(openResult) withObject:self afterDelay:1];
        
    } failureComplection:^(NSDictionary * _Nonnull done) {
        NSInteger rStatus = [done[@"status"] integerValue];
        if (rStatus == MONEY_STATE_HAS_GONE || rStatus == MONEY_STATE_OUTOFTIME) {
            /// 1-已经抢完了 2-已经过期
            [self.lManager single_updateMessage:self.message status:rStatus];
            self.status = rStatus;
            [self performSelector:@selector(openResult) withObject:self afterDelay:1];
            [self.lManager.vc reloadMessage];
        }  else {
            /// 失败重新抢
            [ToastManager showToast:done[@"msg"] inView:self];
            [self.roateImage.layer removeAllAnimations];
            [self.luckyMoney setUserInteractionEnabled:YES];
            [self addGestureRecognizer:self->_closeTap];
        }
    }];
}
// MARK: 显示转
- (void)layerRotation {
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.35f;
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 1.35f;
    group.repeatCount = CGFLOAT_MAX;
    group.removedOnCompletion = NO;
    [group setAnimations:@[rotationAnimation]];
    [self.roateImage.layer addAnimation:group forKey:@"bindCardImageViewAnimation"];
    [self.luckyMoney setUserInteractionEnabled:NO];
    [self removeGestureRecognizer:_closeTap];
}
// MARK:打开红包之后显示
- (void)openResult {
    
    if (self.status == 1001) {
        self.noteLabel.text = @"手慢了，红包派完了";
        [self.openBtn setHidden:YES];
        return;
    }
    
    CGRect tFrame = self.topRedbg.frame;
    tFrame.origin = CGPointMake(tFrame.origin.x, tFrame.origin.x);
    CGRect bFrame = self.bottomRedbg.frame;
    bFrame.origin = CGPointMake(bFrame.origin.x, bFrame.origin.y + 800);
    CGRect mFrame = self.luckyMoney.frame;
    mFrame.origin = CGPointMake(mFrame.origin.x, mFrame.origin.y - 400);
    mFrame.size = CGSizeMake(mFrame.size.width, mFrame.size.height + 800);
    [self.detailBtn setHidden:YES];
    [self.openBtn setHidden:YES];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.topRedbg.frame = tFrame;
        self.bottomRedbg.frame = bFrame;
        self.luckyMoney.frame = mFrame;
    } completion:^(BOOL finished) {
        self.alpha = 0;
        [self removeFromSuperview];
    }];
    LuckyMoneyDetailViewController *lvc = [[LuckyMoneyDetailViewController alloc] init];
    lvc.isGroup = self.message.conversation.type != Single_Type;
    lvc.allRecord = self->allRecordsModel;
    lvc.redPId = self->allRecordsModel.redPId;
    lvc.conversationId = self.message.conversation.target;
    [self.lManager.vc.navigationController pushViewController:lvc animated:YES];
//    [self.lManager.vc presentViewController:lvc animated:NO completion:nil];
}
/// 已经抢完UI
- (void)noMoneyToRob {
    [self.openBtn setHidden:YES];
    self.noteLabel.text = @"手慢了，红包派完了";
}
// MARK: 隐藏抢
- (void)hiddenSelf{
    [UIView animateWithDuration:0.5 animations:^{
        self.luckyMoney.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self.luckyMoney.alpha = 0;
        self.closeBtn.alpha = 0;
    } completion:^(BOOL finished) {
        self.luckyMoney.alpha = 1;
        self.closeBtn.alpha = 1;
        self.luckyMoney.transform = CGAffineTransformIdentity;
        [self removeFromSuperview];
    }];
}
// MARK: 显示抢UI
- (void)showBg {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.luckyMoney.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.luckyMoney.transform = CGAffineTransformIdentity;
    } completion:nil];
}

@end
