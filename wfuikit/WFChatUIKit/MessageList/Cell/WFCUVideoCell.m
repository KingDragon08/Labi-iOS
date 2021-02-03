//
//  VideoCell.m
//  WFChat UIKit
//
//  Created by WF Chat on 2017/9/2.
//  Copyright © 2017年 WildFireChat. All rights reserved.
// 视频cell

#import "WFCUVideoCell.h"
#import <WFChatClient/WFCChatClient.h>

@interface WFCUVideoCell ()
@property(nonatomic, strong) UIImageView *shadowMaskView;
@end

@implementation WFCUVideoCell

+ (CGSize)sizeForClientArea:(WFCUMessageModel *)msgModel withViewWidth:(CGFloat)width {
    WFCCVideoMessageContent *imgContent = (WFCCVideoMessageContent *)msgModel.message.content;
    CGSize size = imgContent.thumbnail.size;
    CGFloat max = 150;
    CGFloat vHeight = size.height;
    CGFloat vWidth = size.width;
    CGFloat temp = vHeight;
    if (vHeight > vWidth) {
        if (vHeight > max) {
            vHeight = max;
            vWidth = vHeight / temp * vWidth;
        }
    } else {
        temp = vWidth;
        if (vWidth > max) {
            vWidth = max;
            vHeight = vWidth / temp * vHeight;
        }
    }
    return CGSizeMake(vWidth, vHeight);
}

- (void)setModel:(WFCUMessageModel *)model {
    [super setModel:model];
    WFCCVideoMessageContent *imgContent = (WFCCVideoMessageContent *)model.message.content;
    
    self.thumbnailView.frame = self.bubbleView.bounds;
    self.thumbnailView.image = imgContent.thumbnail;
    self.videoCoverView.frame = CGRectMake((self.bubbleView.bounds.size.width - 30)/2, (self.bubbleView.bounds.size.height - 30)/2, 30, 30);
    self.videoCoverView.image = [UIImage imageNamed:@"video_msg_cover"];
    self.durationLabel.text = imgContent.duration;
    self.durationLabel.frame = CGRectMake(self.bubbleView.bounds.size.width - 60, self.bubbleView.bounds.size.height - 20, 50, 20);
}

- (UIImageView *)thumbnailView {
    if (!_thumbnailView) {
        _thumbnailView = [[UIImageView alloc] init];
        [self.bubbleView addSubview:_thumbnailView];
    }
    return _thumbnailView;
}

- (UIImageView *)videoCoverView {
    if (!_videoCoverView) {
        _videoCoverView = [[UIImageView alloc] init];
        _videoCoverView.backgroundColor = [UIColor clearColor];
        [self.bubbleView addSubview:_videoCoverView];
    }
    return _videoCoverView;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.textColor = [UIColor whiteColor];
        _durationLabel.font = [UIFont systemFontOfSize:10];
        _durationLabel.textColor = [UIColor whiteColor];
        _durationLabel.textAlignment = NSTextAlignmentRight;
        [self.bubbleView addSubview:_durationLabel];
    }
    return _durationLabel;
}

- (void)setMaskImage:(UIImage *)maskImage{
    [super setMaskImage:maskImage];
    if (_shadowMaskView) {
        [_shadowMaskView removeFromSuperview];
    }
    _shadowMaskView = [[UIImageView alloc] initWithImage:maskImage];
    
    CGRect frame = CGRectMake(self.bubbleView.frame.origin.x, self.bubbleView.frame.origin.y, self.bubbleView.frame.size.width, self.bubbleView.frame.size.height);
    _shadowMaskView.frame = frame;
    [self.contentView addSubview:_shadowMaskView];
    [self.contentView bringSubviewToFront:self.bubbleView];
}

@end
