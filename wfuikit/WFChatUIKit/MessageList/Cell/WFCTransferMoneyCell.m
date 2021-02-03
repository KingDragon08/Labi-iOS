//
//  WFCTransferMoneyCell.m
//  WFChatUIKit
//
//  Created by xxx on 2019/11/18.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "WFCTransferMoneyCell.h"
#import "MessageContentModel.h"

@interface WFCTransferMoneyCell ()

@property(nonatomic, strong) UIImageView *orangeBg;
@property (nonatomic, strong)UILabel *stateLabel;
@property (nonatomic, strong)UIImageView *redBag;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong) UILabel *wehatLabel;
@property (nonatomic, strong)UIView *whiteBag;

@end

@implementation WFCTransferMoneyCell

+ (CGSize)sizeForClientArea:(WFCUMessageModel *)msgModel withViewWidth:(CGFloat)width {
    return CGSizeMake(240, 80);
}

- (void)setModel:(WFCUMessageModel *)model {
    [super setModel:model];
    
    WFCCTransferMoneyMessage *txtContent = (WFCCTransferMoneyMessage *)model.message.content;
    self.orangeBg.backgroundColor = [UIColor colorWithRed:243/255.0 green:139/255.0 blue:47/255.0 alpha:1.0];
    MessageContentModel *mModel = [MessageContentModel findMessage:model.message.messageUid];
    if (!mModel) {
        mModel = [MessageContentModel messageWithJson:txtContent.extra];
    }
    self.titleLabel.text = [NSString stringWithFormat:@"¥%.2f",mModel.money.doubleValue/100.0];
    NSLog(@"EXTRA_______%@___redPid_%@", mModel.extra, mModel.redPId);
    
    if (mModel.status == 1) {
        /// 如果已经被领取显示
        self.stateLabel.text = [NSString stringWithFormat:@"已被领取"];
        self.whiteBag.alpha = 0.8;
        self.redBag.image = [UIImage imageNamed:@"c2c_received_icon"];
    } else if (mModel.status == 0) {
        /// 没有被领取时UI
        self.whiteBag.alpha = 0;
        if (mModel.note.length == 0) {
            self.stateLabel.text = @"转账";
        } else {
            self.stateLabel.text = mModel.note;
        }
        self.redBag.image = [UIImage imageNamed:@"c2c_transfer_icon"];
    } else if (mModel.status == 10) {
        /// 已经过期--
        self.whiteBag.alpha = 0;
        self.stateLabel.text = @"已过期";
        self.whiteBag.alpha = 0.8;
        self.redBag.image = [UIImage imageNamed:@"c2c_transfer_icon"];
    }
    
    if (model.message.direction == MessageDirection_Receive) {
        _redBag.frame = CGRectMake(15, 15, 40, 40);
        _stateLabel.frame = CGRectMake(62, 40, self.bubbleView.frame.size.width - 70, 13);
        _titleLabel.frame = CGRectMake(62, 12, self.bubbleView.frame.size.width-50, 20);
        _wehatLabel.frame = CGRectMake(15, 68, 100, 22);
    }
}

- (UIImageView *)orangeBg {
    if (_orangeBg == nil) {
        _orangeBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bubbleView.frame.size.width, 68)];
        _orangeBg.backgroundColor = [UIColor orangeColor];
        [self.bubbleView addSubview:_orangeBg];
        [self.bubbleView insertSubview:self.whiteBag aboveSubview:_orangeBg];
        self.wehatLabel.text = @"微信转账";
        [self.redBag setHidden:NO];
    }
    return _orangeBg;
}

- (UIImageView *)redBag {
    if (_redBag == nil) {
        _redBag = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 40, 40)];
        _redBag.image = [UIImage imageNamed:@"c2c_received_icon"];
        [self.bubbleView addSubview:_redBag];
        [self.bubbleView bringSubviewToFront:_redBag];
    }
    return _redBag;
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
        _stateLabel.frame = CGRectMake(57, 40, self.bubbleView.frame.size.width - 70, 13);
        [self.bubbleView addSubview:_stateLabel];
        [self.bubbleView bringSubviewToFront:_stateLabel];
    }
    return _stateLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 12, self.bubbleView.frame.size.width-50, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:18];
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
        _wehatLabel.text = @"微信转账";
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

