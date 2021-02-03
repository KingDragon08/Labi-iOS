//
//  TransferMoneyAcceptedCell.m
//  WFChatUIKit
//
//  Created by xxx on 2019/11/19.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "TransferMoneyAcceptedCell.h"
#import "MessageContentModel.h"
@interface TransferMoneyAcceptedCell ()

@property(nonatomic, strong)  UIImageView *orangeBg;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIImageView *redBag;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *wehatLabel;
@property (nonatomic, strong) UIView *whiteBag;

@end

@implementation TransferMoneyAcceptedCell

+ (CGSize)sizeForClientArea:(WFCUMessageModel *)msgModel withViewWidth:(CGFloat)width {
    return CGSizeMake(240, 70);
}

- (void)setModel:(WFCUMessageModel *)model {
    [super setModel:model];
    
    TransferMoneyAcceptModel *txtContent = (TransferMoneyAcceptModel *)model.message.content;
    self.orangeBg.backgroundColor = [UIColor colorWithRed:243/255.0 green:139/255.0 blue:47/255.0 alpha:1.0];
    MessageContentModel *extraModel = [MessageContentModel messageWithJson:txtContent.extra];
    
    /// 转账主要信息，显示钱数,红包显示备注信息
    self.titleLabel.text = [NSString stringWithFormat:@"¥%.2f",extraModel.money.doubleValue/100.0];
    /// 如果有转账备注，需要显示备注信息
    self.stateLabel.text = @"已收款";
    self.whiteBag.alpha = 0.8;
    self.redBag.image = [UIImage imageNamed:@"c2c_received_icon"];
    
    if (model.message.direction == MessageDirection_Receive) {
        _redBag.frame = CGRectMake(15, 10, 40, 40);
        _stateLabel.frame = CGRectMake(62, 35, self.bubbleView.frame.size.width - 70, 13);
        _titleLabel.frame = CGRectMake(62, 10, self.bubbleView.frame.size.width-50, 20);
        _wehatLabel.frame = CGRectMake(15, 58, 100, 22);
    }
}

- (UIImageView *)orangeBg {
    if (_orangeBg == nil) {
        _orangeBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bubbleView.frame.size.width, 58)];
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
        _redBag = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        _redBag.image = [UIImage imageNamed:@"c2c_received_icon"];
        [self.bubbleView addSubview:_redBag];
        [self.bubbleView bringSubviewToFront:_redBag];
    }
    return _redBag;
}

- (UIView *)whiteBag {
    if (_whiteBag == nil) {
        _whiteBag = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bubbleView.frame.size.width, 58)];
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
        _stateLabel.frame = CGRectMake(57, 35, self.bubbleView.frame.size.width - 70, 13);
        [self.bubbleView addSubview:_stateLabel];
        [self.bubbleView bringSubviewToFront:_stateLabel];
    }
    return _stateLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 10, self.bubbleView.frame.size.width-50, 20)];
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
        _wehatLabel.frame = CGRectMake(10, 58, 100, 22);
        _wehatLabel.text = @"微信转账";
        [self.bubbleView addSubview:_wehatLabel];
        UILabel *white = [[UILabel alloc] initWithFrame:CGRectMake(0, 58, self.bubbleView.frame.size.width, 22)];
        white.backgroundColor = [UIColor whiteColor];
        [self.bubbleView addSubview:white];
        [self.bubbleView addSubview:_wehatLabel];
        [self.bubbleView bringSubviewToFront:_wehatLabel];
    }
    return _wehatLabel;
}


@end

