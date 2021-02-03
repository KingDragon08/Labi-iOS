//
//  NewFriendTableViewCell.m
//  WFChat UIKit
//
//  Created by WF Chat on 2017/10/28.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#import "WFCUNewFriendTableViewCell.h"
#import <WFChatClient/WFCChatClient.h>
#import "SDWebImage.h"


@interface WFCUNewFriendTableViewCell ()

@end

@implementation WFCUNewFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)onFriendRequestUpdated:(NSNotification *)notification {
    [self updateBubbleNumber];
}

- (void)updateBubbleNumber {
    int unreadCount = [[WFCCIMService sharedWFCIMService] getUnreadFriendRequestStatus];
    if (unreadCount) {
        self.bubbleView.hidden = NO;
        [self.bubbleView setBubbleTipNumber:unreadCount];
    } else {
        self.bubbleView.hidden = YES;
    }
}

- (void)refresh {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFriendRequestUpdated:) name:kFriendRequestUpdated object:nil];
    
    [self updateBubbleNumber];
}

- (BubbleTipView *)bubbleView {
    if (!_bubbleView) {
        if (self.portraitView) {
            _bubbleView = [[BubbleTipView alloc] initWithParentView:self.contentView];
            _bubbleView.hidden = YES;
        }
    }
    return _bubbleView;
}

- (UIImageView *)portraitView {
    if (!_portraitView) {
        _portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 8, 40, 40)];
        _portraitView.layer.masksToBounds = YES;
        _portraitView.layer.cornerRadius = 3.f;
        [self.contentView addSubview:_portraitView];
//        UIView *line = [UIView new];
//        line.backgroundColor = [UIColor colorWithRed:207/255.0 green:208/255.0 blue:209/255.0 alpha:1.f];
//        CGFloat lineHeight =  1/[UIScreen mainScreen].scale;
//        line.frame = CGRectMake(56, 56 - lineHeight, 700, lineHeight);
//        [self.contentView addSubview:line];
    }
    return _portraitView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(67, 18, [UIScreen mainScreen].bounds.size.width - 67, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
