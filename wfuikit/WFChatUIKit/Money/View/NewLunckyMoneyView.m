//
//  NewLunckyMoneyView.m
//  WFChatUIKit
//
//  xxxxx on 2018/11/22.
//  Copyright © 2018 Tom Lee. All rights reserved.
//

#import "NewLunckyMoneyView.h"
#import "ZBLocalized.h"
#import "LNNumberScrollAnimatedView.h"
#import "Predefine.h"
#import "MessageContentModel.h"
#import "RobLuckyMoneyManager.h"
#import "SDWebImage.h"
#import "LuckyMoneyDetailViewController.h"
static int aniDuration = 2;
static BOOL isShow = NO;
@interface NewLunckyMoneyView() {
    UIView *_moneyView;
    CGFloat _endX;
    CGFloat _endY;
    CGFloat _endW;
    CGFloat _endH;
    
    LNNumberScrollAnimatedView *_left;
    LNNumberScrollAnimatedView *_right;
    UILabel *_leftLabel;
    UILabel *_rightLabel;
    UIView *_openView;
    UIView *_openedView;
    UILabel *_point;
    NSString *_moneyStr;
    
    LuckyMoneyListModel *allRecordsModel;
}
@property (nonatomic, strong) WFCCMessage *message;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *redPId;
@property (nonatomic, strong) LuckyManager *lManager;
@end

@implementation NewLunckyMoneyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
        isShow = YES;
    }
    return self;
}

+ (NewLunckyMoneyView *)showBgWithMessage:(WFCCMessage *)message status:(NSInteger)status {
    if (isShow) {
        return nil;
    }
    NewLunckyMoneyView *nv = [NewLunckyMoneyView new];
    nv.message = message;
    nv.status = status;
    [nv showBg];
    [nv initNumLabel];
    return nv;
}
+ (void)showLuckyMoney {
    if (isShow) {
        return;
    }
    NewLunckyMoneyView *nv = [NewLunckyMoneyView new];
    [nv showBg];
    [nv initNumLabel];
}

- (void)closeSelf {
    isShow = NO;
    [self removeFromSuperview];
}

- (void)detailShow {
    LuckyMoneyDetailViewController *lvc = [[LuckyMoneyDetailViewController alloc] init];
    lvc.redPId = self.redPId;
    lvc.isGroup = NO;
    lvc.conversationId = self.message.conversation.target;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//         [self closeSelf];
//    });
    [self.lManager.vc.navigationController pushViewController:lvc animated:YES];
    [self closeSelf];
}

- (void)openLuckyMoney:(NSString *)num {
    _openedView.hidden = NO;
    [self bringSubviewToFront:_openedView];
    NSArray <NSString *>*array = [num componentsSeparatedByString:@"."];
    if (array.count > 0) {
        [_right setValue:[NSNumber numberWithInt:[array[1] intValue]]];
        [_right startAnimation];
        [_left setValue:[NSNumber numberWithInt:[array[0] intValue]]];
        [_left startAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(aniDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _leftLabel.hidden = NO;
            _leftLabel.text = array[0];
            _left.hidden = YES;
            _point.hidden = NO;
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(aniDuration * 1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _rightLabel.hidden = NO;
            _rightLabel.text = array[1];
            _right.hidden = YES;
        });
    } else {
        [_left setValue:[NSNumber numberWithInt:[array[0] intValue]]];
        [_left startAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(aniDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _leftLabel.hidden = NO;
            _leftLabel.text = array[0];
            _left.hidden = YES;
            _point.hidden = YES;
        });
        
    }
}



- (void)robLuckyMoney {
    NSString *userId = [[WFCCNetworkService sharedInstance] userId];
    NSDictionary *param = @{@"userId":userId,@"redPId":self.redPId};
    
    [[NetworkAPI sharedInstance] postWithUrl:MONEY_LUCKYMONEY_ROB params:param successComplection:^(NSDictionary * _Nonnull done) {
        self->allRecordsModel = [LuckyMoneyListModel mj_objectWithKeyValues:done[@"data"]];
        MoneyRecordModel *record = self->allRecordsModel.mineRecord;
        self.status = [[NSString stringWithFormat:@"%@",done[@"data"][@"status"]] integerValue];
        if (!record) {
            /// 没有抢到
            [ToastManager showToast:@"没抢到" inView:self];
            [self.lManager single_updateMessage:self.message status:self.status];
        } else {
            NSString *str1 = [NSString stringWithFormat:@"%.2f", record.money.intValue/100.0f];
            [self openLuckyMoney:str1];
            MessageContentModel *mContent = [MessageContentModel messageWithJson:self.message.content.extra];
            mContent.money = [NSString stringWithFormat:@"%ld", record.money.intValue];
            self.message.content.extra = [mContent jsonWithMessage];
            /// 本人已经领取了 10 -本人已经领取了
            /// 单人已经领取成功，则需要发送已经领取的红包消息
            [self.lManager single_updateMessage:self.message status:MONEY_STATE_HAS_ROBED];
            [self.lManager single_insertAcceptMessage:self.message status:MONEY_STATE_HAS_ROBED];
        }
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
        }
    }];
}


- (void)initNumLabel {
    WFCCUserInfo *user = [[WFCCIMService sharedWFCIMService] getUserInfo:self.message.fromUser refresh:NO];
    MessageContentModel *cModel = [MessageContentModel messageWithJson:self.message.content.extra];
    self.redPId = cModel.redPId;
    UIFont *font = [UIFont boldSystemFontOfSize:20];
    UIColor *tColor = UIColor.redColor;
    CGFloat xx = 10;
    CGFloat yy = 80;
    CGFloat ff = 100;
    CGFloat ww = 70;
    CGFloat _font = 45;
    
    LNNumberScrollAnimatedView *socreAnimation = [[LNNumberScrollAnimatedView alloc] initWithFrame:CGRectMake(xx, 25, ww, ff)];
    socreAnimation.textColor = HEXCOLOR(0xC5A14A);
    socreAnimation.font = [UIFont boldSystemFontOfSize:_font];
    [socreAnimation setValue:@3];
    [socreAnimation sizeToFit];
    socreAnimation.density = 21;
    socreAnimation.duration = aniDuration;
    socreAnimation.minLength = 2;
    socreAnimation.isAscending = NO;
    socreAnimation.durationOffset = 0.1;
    _left = socreAnimation;
    
    _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(_left.frame.origin.x - 2, _left.frame.origin.y, _left.frame.size.width, _left.frame.size.height)];
    _leftLabel.font = [UIFont boldSystemFontOfSize:_font];
    _leftLabel.textColor = HEXCOLOR(0xC5A14A);
    _leftLabel.hidden = YES;
    _leftLabel.textAlignment = NSTextAlignmentRight;
    
    xx = xx + ww;
    
    _point = [[UILabel alloc] initWithFrame:CGRectMake(xx-5, 25, 10, ff + 2)];
    _point.textAlignment = NSTextAlignmentCenter;
    _point.font = [UIFont boldSystemFontOfSize:_font];
    _point.text = @".";
    _point.textColor = HEXCOLOR(0xC5A14A);
    xx = xx + 4;
    
    LNNumberScrollAnimatedView *rsocreAnimation = [[LNNumberScrollAnimatedView alloc] initWithFrame:CGRectMake(xx, 25, ww, ff + 2)];
    rsocreAnimation.textColor = HEXCOLOR(0xC5A14A);
    rsocreAnimation.font = [UIFont boldSystemFontOfSize:_font];
    [rsocreAnimation setValue:@30];
    [rsocreAnimation sizeToFit];
    rsocreAnimation.density = 30;
    rsocreAnimation.duration = aniDuration * 1.5;
    rsocreAnimation.minLength = 2;
    rsocreAnimation.isAscending = NO;
    rsocreAnimation.durationOffset = 0.1;
    _right = rsocreAnimation;
    
    _rightLabel = [[UILabel alloc] initWithFrame: _right.frame];
    _rightLabel.font = [UIFont boldSystemFontOfSize:_font];
    _rightLabel.textColor = HEXCOLOR(0xC5A14A);
    _rightLabel.hidden = YES;
    _rightLabel.textAlignment = NSTextAlignmentLeft;
    
    UIImageView *opened = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newredbagopened"]];
    opened.hidden =  NO;
    opened.layer.masksToBounds = YES;
    opened.layer.cornerRadius = 18.0;
    opened.userInteractionEnabled = YES;
    opened.frame = _openView.bounds;
    [_openedView addSubview:opened];
    [_openedView addSubview:_left];
    [_openedView addSubview:_point];
    [_openedView addSubview:_right];
    [_openedView addSubview:_leftLabel];
    [_openedView addSubview:_rightLabel];
    
    UILabel *yuan = [[UILabel alloc] initWithFrame:CGRectMake(_openedView.frame.size.width - 40, 75, 30, 20)];
    yuan.text = @"元";
    yuan.font = [UIFont boldSystemFontOfSize:15.0];
    yuan.textColor = HEXCOLOR(0xC5A14A);
    yuan.textAlignment = NSTextAlignmentRight;
    _point.hidden = YES;
    [_openedView addSubview:yuan];
}

- (void)showBg {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self->_moneyView.frame = CGRectMake(_endX, _endY, _endW, _endH);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)initView {
    UIView *bg = [UIView new];
    bg.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.85];
    [self addSubview:bg];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSelf)];
    [bg addGestureRecognizer:tap];
    
    _moneyView = [UIView new];
    [self addSubview:_moneyView];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"newredbag"];
    CGFloat w = UIScreen.mainScreen.bounds.size.width;
    CGFloat h = UIScreen.mainScreen.bounds.size.height;
    self.frame = CGRectMake(0, 0, w, h);
    bg.frame = self.bounds;
    
    CGFloat rW = 180;
    CGFloat cH = 50;
    CGFloat topW = 44;
    CGFloat rh = rW + topW + 70 + cH;
    CGFloat ww = rW + 88;
    
    _endX = (w - ww)/2;
    _endY = (h - rh)/2;
    _endW = ww;
    _endH = rh;
    _moneyView.frame = CGRectMake(_endX, _endY - 1000, _endW, _endH);
    
    _moneyView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(robLuckyMoney)];
    [_moneyView addGestureRecognizer:tap1];
    
    imageView.frame = CGRectMake(topW, topW, rW, rW * 72/57);
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 18;
    _openView = imageView;
    [_moneyView addSubview:imageView];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *tImage = [[UIImage imageNamed:@"close_red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [close setImage:tImage forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
    [_moneyView addSubview:close];
    close.frame = CGRectMake(ww - topW - 10, 10, topW, topW);
    
    UIButton *detail = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *str = [NSString stringWithFormat:@"%@ >", WFCString(@"ViewClaimDetails")];
    [detail setTitle:str forState:UIControlStateNormal];
    detail.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    detail.titleLabel.textAlignment = NSTextAlignmentRight;
    [detail addTarget:self action:@selector(detailShow) forControlEvents:UIControlEventTouchUpInside];
    
    [_moneyView addSubview:detail];
    [detail setTitleColor:HEXCOLOR(0xC5A14A) forState:UIControlStateNormal];
    detail.frame = CGRectMake(imageView.frame.origin.x, CGRectGetMaxY(imageView.frame) + 5 , rW - 10, cH);
    _openedView = [[UIView alloc] initWithFrame:_openView.frame];
    [_moneyView addSubview:_openedView];
    _openedView.hidden = YES;
}

@end
