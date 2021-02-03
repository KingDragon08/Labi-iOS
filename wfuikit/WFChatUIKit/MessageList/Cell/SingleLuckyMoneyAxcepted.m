//
//  SingleLuckyMoneyAxcepted.m
//  WFChatUIKit
//
//  Created by shangguan on 2019/11/27.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "SingleLuckyMoneyAxcepted.h"
#import <WFChatClient/WFCChatClient.h>
#import "WFCUUtilities.h"
#import "MessageContentModel.h"
#import "LuckyMoneyDetailViewController.h"

#define TEXT_TOP_PADDING 6
#define TEXT_BUTTOM_PADDING 6
#define TEXT_LEFT_PADDING 8
#define TEXT_RIGHT_PADDING 8


#define TEXT_LABEL_TOP_PADDING TEXT_TOP_PADDING + 4
#define TEXT_LABEL_BUTTOM_PADDING TEXT_BUTTOM_PADDING + 4
#define TEXT_LABEL_LEFT_PADDING 30
#define TEXT_LABEL_RIGHT_PADDING 30

@interface SingleLuckyMoneyAxcepted ()

@property (nonatomic, strong)UIImageView *redbagImage;
@property (nonatomic, strong)UIButton *redbagButton;
@property (nonatomic, strong) WFCUMessageModel *cModel;

@end

@implementation SingleLuckyMoneyAxcepted

+ (CGSize)sizeForCell:(WFCUMessageModel *)msgModel withViewWidth:(CGFloat)width {
    msgModel.showTimeLabel = NO;
    CGFloat height = [super hightForTimeLabel:msgModel];
    NSString *infoText;
    
    if ([msgModel.message.content isKindOfClass:[LuckyMoneyAcceptMessageContent class]]) {
        infoText = [self getContentFromMessage:msgModel.message];
    }
    CGSize size = [WFCUUtilities getTextDrawingSize:infoText font:[UIFont systemFontOfSize:14] constrainedSize:CGSizeMake(width - TEXT_LABEL_LEFT_PADDING - TEXT_LABEL_RIGHT_PADDING - TEXT_LEFT_PADDING - TEXT_RIGHT_PADDING, 14)];
    size.height += TEXT_LABEL_TOP_PADDING + TEXT_BUTTOM_PADDING;
    size.height += height;
    if (width > gScreenWidth - 100) {
        width = gScreenWidth - 100;
    }
    return CGSizeMake(width, 0);
    
    return CGSizeZero;
}

+ (NSString *)getContentFromMessage:(WFCCMessage *)message {
    return @"";
    NSString *textContent;
    MessageContentModel  *amodel = [MessageContentModel messageWithJson:message.content.extra];
    if ([amodel.senderId isEqualToString:amodel.targetId]) {
        return @"你领取了自己发的";
    }
    if (message.direction == MessageDirection_Send) {
        textContent = [NSString stringWithFormat:@"你领取了%@的",amodel.targetName];
    } else if (message.direction == MessageDirection_Receive) {
        if (message.conversation.type == !Single_Type) {
            NSString *contenStr;
            WFCCUserInfo * targetUser = [[WFCCIMService sharedWFCIMService] getUserInfo:message.fromUser inGroup:message.conversation.target refresh:NO];
            if (targetUser.friendAlias.length > 0) {
                contenStr = targetUser.friendAlias;
            } else if(targetUser.groupAlias.length > 0) {
                contenStr = targetUser.groupAlias;
            } else if (targetUser.displayName.length > 0) {
                contenStr = targetUser.displayName;
            } else {
                contenStr = targetUser.name;
            }
            textContent = [NSString stringWithFormat:@"%@领取了你的",contenStr];
            return textContent;
        }
        NSString *contenStr;
        WFCCUserInfo * targetUser = [[WFCCIMService sharedWFCIMService] getUserInfo:message.fromUser refresh:NO];
        if(targetUser.friendAlias.length) {
            contenStr = targetUser.friendAlias;
        } else if (targetUser.displayName.length > 0) {
            contenStr = targetUser.displayName;
        } else {
            contenStr = targetUser.name;
        }
        textContent = [NSString stringWithFormat:@"%@领取了你的",contenStr];
    }
    return textContent;
}

- (void)redBagClick {
    LuckyMoneyDetailViewController *lvc = [[LuckyMoneyDetailViewController alloc] init];
    MessageContentModel *m = [MessageContentModel messageWithJson:self.cModel.message.content.extra];
    if ([self viewController] && m.redPId) {
        lvc.redPId = m.redPId;
        lvc.conversationId = self.cModel.message.conversation.target;
        [[self viewController].navigationController pushViewController:lvc animated:YES];
    }
}

- (void)setModel:(WFCUMessageModel *)model {
    [super setModel:model];
    _cModel = model;
    NSString *infoText;
    if ([model.message.content isKindOfClass:[LuckyMoneyAcceptMessageContent class]]) {
        infoText = [SingleLuckyMoneyAxcepted getContentFromMessage:model.message];
    }
    
    CGFloat width = self.contentView.bounds.size.width;
    CGFloat offset = TEXT_LABEL_LEFT_PADDING - TEXT_LABEL_RIGHT_PADDING - TEXT_LEFT_PADDING - TEXT_RIGHT_PADDING;
    CGSize size = [WFCUUtilities getTextDrawingSize:infoText font:[UIFont systemFontOfSize:14] constrainedSize:CGSizeMake(width - offset, 20)];
    if (width > gScreenWidth - 100) {
        width = gScreenWidth - 100;
    }
    
    
    self.infoLabel.text = infoText;
    CGFloat timeLableEnd = 0;
    if (!self.timeLabel.hidden) {
        timeLableEnd = self.timeLabel.frame.size.height + self.timeLabel.frame.origin.y;
    }
    self.infoLabel.frame = CGRectMake((width - size.width)/2, timeLableEnd + TEXT_LABEL_TOP_PADDING, size.width + 1, size.height + TEXT_TOP_PADDING + TEXT_BUTTOM_PADDING);
    CGFloat minY = self.infoLabel.frame.origin.y;
    self.redbagImage.frame = CGRectMake(CGRectGetMinX(self.infoLabel.frame)-16, minY, 16, 16);
    self.redbagButton.frame = CGRectMake(CGRectGetMaxX(self.infoLabel.frame)-1, minY, 30, 14);
    CGPoint iCenter = self.redbagImage.center;
    CGPoint bCenter = self.redbagButton.center;
    iCenter.y = self.infoLabel.center.y;
    bCenter.y = iCenter.y;
    self.redbagImage.center = iCenter;
    self.redbagButton.center = bCenter;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.numberOfLines = 0;
        _infoLabel.font = [UIFont systemFontOfSize:14];
        _infoLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.textColor = [UIColor colorWithRed:165/255.0 green:166/255.0 blue:167/255.0 alpha:1.0];
        [self.contentView addSubview:_infoLabel];
    }
    return _infoLabel;
    
}

- (UIImageView *)redbagImage {
    if (!_redbagImage) {
        _redbagImage = [[UIImageView alloc] init];
//        [_redbagImage setImage:[UIImage imageNamed:@"AlbumPushLuckymoneyIcon"]];
        [self.contentView addSubview:_redbagImage];
    }
    return _redbagImage;
}

- (UIButton *)redbagButton {
    if (!_redbagButton) {
        _redbagButton = [[UIButton alloc] init];
//        [_redbagButton setTitle:@"红包" forState:UIControlStateNormal];
//        _redbagButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        [_redbagButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_redbagButton];
//        [_redbagButton addTarget:self action:@selector(redBagClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _redbagButton;
}

- (UIViewController *)viewController{
    UIResponder *parentResponder = self;
    while (parentResponder != nil) {
        parentResponder = parentResponder.nextResponder;
        if ([parentResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)parentResponder;
        }
    }
    return nil;
}


@end
