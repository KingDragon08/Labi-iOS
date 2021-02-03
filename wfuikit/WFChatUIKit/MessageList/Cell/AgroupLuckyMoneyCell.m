//
//  AgroupLuckyMoneyCell.m
//  WFChatUIKit
//
//  Created by shangguan on 2019/11/27.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "AgroupLuckyMoneyCell.h"
#import "MessageContentModel.h"
#define kShakingRadian(R) ((R) / 180.0 * M_PI)
@interface AgroupLuckyMoneyCell ()

@property(nonatomic, strong) UIImageView *orangeBg;
@property (nonatomic, strong)UILabel *stateLabel;
@property (nonatomic, strong)UIImageView *redBag;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong) UILabel *wehatLabel;
@property (nonatomic, strong)UIView *whiteBag;

@end

@implementation AgroupLuckyMoneyCell

+ (CGSize)sizeForClientArea:(WFCUMessageModel *)msgModel withViewWidth:(CGFloat)width {
    return CGSizeMake(90, 122);
}

- (void)setModel:(WFCUMessageModel *)model {
    [super setModel:model];
    self.redBag;
    
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    
    animation.keyPath = @"transform.rotation";
    
    animation.values = @[@(kShakingRadian(-8)),  @(kShakingRadian(8)), @(kShakingRadian(-8))];
    
    animation.duration = 0.25;
    
    // 动画的重复执行次数
    animation.repeatCount = MAXFLOAT;
    
    // 保持动画执行完毕后的状态
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    [self.bubbleView.layer addAnimation:animation forKey:@"shakeAnimation"];
    /*
    WFCCTextMessageContent *txtContent = (WFCCTextMessageContent *)model.message.content;
    MessageContentModel *mModel = [MessageContentModel findMessage:model.message.messageUid];
    if (!mModel) {
        mModel = [MessageContentModel messageWithJson:txtContent.extra];
    }
    self.orangeBg.backgroundColor = [UIColor colorWithRed:243/255.0 green:139/255.0 blue:47/255.0 alpha:1.0];
    if (mModel.status == MONEY_STATE_HAS_ROBED) {
        self.titleLabel.text = mModel.note;
        self.stateLabel.text = @"已领取";
        [self.stateLabel setHidden:NO];
        self.whiteBag.alpha = 0.8;
        _redBag.image = [UIImage imageNamed:@"redenvelope_handled"];
        self.titleLabel.frame = CGRectMake(57, 12, self.bubbleView.frame.size.width-50, 20);
        if (model.message.direction == MessageDirection_Receive) {
            self.titleLabel.frame = CGRectMake(62, 12, self.bubbleView.frame.size.width-50, 20);
        }
    } else {
        self.titleLabel.text = mModel.note;
        [self.stateLabel setHidden:YES];
        self.whiteBag.alpha = 0;
        _redBag.image = [UIImage imageNamed:@"c2c_hongbao"];
        if (model.message.direction == MessageDirection_Receive) {
            self.titleLabel.frame = CGRectMake(62, 24, self.bubbleView.frame.size.width-50, 20);
        } else {
            self.titleLabel.frame = CGRectMake(57, 24, self.bubbleView.frame.size.width-50, 20);
        }
        
        if (mModel.status == MONEY_STATE_OUTOFTIME) {
            /// 已经过期--
            self.stateLabel.text = @"已过期";
            [self.stateLabel setHidden:NO];
            self.whiteBag.alpha = 0.8;
            self.redBag.image = [UIImage imageNamed:@"c2c_hongbao"];
            if (model.message.direction == MessageDirection_Receive) {
                self.titleLabel.frame = CGRectMake(62, 12, self.bubbleView.frame.size.width-50, 20);
            } else {
                self.titleLabel.frame = CGRectMake(57, 12, self.bubbleView.frame.size.width-50, 20);
            }
        } else if (mModel.status == MONEY_STATE_HAS_GONE) {
            self.stateLabel.text = @"已被领完";
            [self.stateLabel setHidden:NO];
            self.whiteBag.alpha = 0.8;
            self.redBag.image = [UIImage imageNamed:@"redenvelope_handled"];
            if (model.message.direction == MessageDirection_Receive) {
                self.titleLabel.frame = CGRectMake(62, 12, self.bubbleView.frame.size.width-50, 20);
            } else {
                self.titleLabel.frame = CGRectMake(57, 12, self.bubbleView.frame.size.width-50, 20);
            }
        }
    }
    
    if (model.message.direction == MessageDirection_Receive) {
        _redBag.frame = CGRectMake(15, 12, 40, 40);
        _stateLabel.frame = CGRectMake(62, 40, self.bubbleView.frame.size.width - 70, 13);
        _wehatLabel.frame = CGRectMake(15, 68, 100, 22);
    }
    */
}

- (UIImageView *)redBag {
    if (_redBag == nil) {
        _redBag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        _redBag.frame = self.bubbleView.bounds;
        _redBag.image = [UIImage imageNamed:@"showredbagcell"];
        [self.bubbleView addSubview:_redBag];
        [self.bubbleView bringSubviewToFront:_redBag];
    }
    return _redBag;
}

- (UIImageView *)orangeBg {
    if (_orangeBg == nil) {
        _orangeBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bubbleView.frame.size.width, 68)];
        _orangeBg.backgroundColor = [UIColor orangeColor];
        [self.bubbleView addSubview:_orangeBg];
        [self.bubbleView insertSubview:self.whiteBag aboveSubview:_orangeBg];
        self.wehatLabel;
        self.redBag;
    }
    return _orangeBg;
}

- (UIView *)whiteBag {
    if (_whiteBag == nil) {
        _whiteBag = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bubbleView.frame.size.width, 68)];
        _whiteBag.backgroundColor = [UIColor whiteColor];
        _whiteBag.alpha = 0;
    }
    return  _whiteBag;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.numberOfLines = 0;
        _stateLabel.font = [UIFont systemFontOfSize:12];
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.userInteractionEnabled = YES;
        _stateLabel.textAlignment = NSTextAlignmentLeft;
        [_stateLabel setHidden:YES];
        _stateLabel.frame = CGRectMake(57, 42, 100, 13);
        [self.bubbleView addSubview:_stateLabel];
        [self.bubbleView bringSubviewToFront:_stateLabel];
    }
    return _stateLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 24, self.bubbleView.frame.size.width-50, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor whiteColor];
        [self.bubbleView addSubview:_titleLabel];
        [self.bubbleView bringSubviewToFront:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)wehatLabel {
    if (!_wehatLabel) {
        _wehatLabel = [[UILabel alloc] init];
        _wehatLabel.font = [UIFont systemFontOfSize:12];
        _wehatLabel.textColor = [UIColor grayColor];
        _wehatLabel.textAlignment = NSTextAlignmentLeft;
        _wehatLabel.frame = CGRectMake(10, 68, 100, 22);
        _wehatLabel.text = @"红包";
        [self.bubbleView addSubview:_wehatLabel];
        UILabel *white = [[UILabel alloc] initWithFrame:CGRectMake(0, 68, self.bubbleView.frame.size.width, 22)];
        white.backgroundColor = [UIColor whiteColor];
        [self.bubbleView addSubview:white];
        [self.bubbleView addSubview:_wehatLabel];
        [self.bubbleView bringSubviewToFront:_wehatLabel];
    }
    return _wehatLabel;
}

@end
