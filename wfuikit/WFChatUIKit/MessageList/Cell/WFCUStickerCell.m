//
//  ImageCell.m
//  WFChat UIKit
//
//  Created by WF Chat on 2017/9/2.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#import "WFCUStickerCell.h"
#import <WFChatClient/WFCChatClient.h>
#import "YLImageView.h"
#import "YLGIFImage.h"
#import "WFCUMediaMessageDownloader.h"
#import "SDWebImage.h"
@interface WFCUStickerCell ()
@property (nonatomic, strong) UIImageView *staticPic;

@end

@implementation WFCUStickerCell

+ (CGSize)sizeForClientArea:(WFCUMessageModel *)msgModel withViewWidth:(CGFloat)width {
    WFCCStickerMessageContent *imgContent = (WFCCStickerMessageContent *)msgModel.message.content;
    
    CGSize size = imgContent.size;
    CGFloat max = 120;
    CGFloat vHeight = size.height;
    CGFloat vWidth = size.width;
    CGFloat temp = vHeight;
    
    if (vHeight > vWidth) {
        if (vHeight > max) {
            vHeight = max;
            vWidth = vHeight / temp * vWidth;
        }
    } else {
        if (vWidth > max) {
            temp = vWidth;
            vWidth = max;
            vHeight = vWidth / temp * vHeight;
        }
    }
    return CGSizeMake(vWidth, vHeight);
}

- (void)setModel:(WFCUMessageModel *)model {
    WFCCStickerMessageContent *stickerMsg = (WFCCStickerMessageContent *)model.message.content;
    __weak typeof(self) weakSelf = self;
    if (!stickerMsg.localPath.length) {
        model.mediaDownloading = YES;
        [[WFCUMediaMessageDownloader sharedDownloader] tryDownload:model.message success:^(long long messageUid, NSString *localPath) {
            if (messageUid == model.message.messageUid) {
                model.mediaDownloading = NO;
                stickerMsg.localPath = localPath;
                [weakSelf setModel:model];
            }
        } error:^(long long messageUid, int error_code) {
            if (messageUid == model.message.messageUid || error_code == -2) {
                model.mediaDownloading = NO;
            }
            
        }];
    }
    [super setModel:model];
    
    self.thumbnailView.frame = self.bubbleView.bounds;
    if (stickerMsg.localPath.length) {
        if ([stickerMsg.remoteUrl componentsSeparatedByString:@".gif"].count > 1 || [stickerMsg.localPath componentsSeparatedByString:@".gif"].count > 1) {
            self.thumbnailView.image = nil;
            self.thumbnailView.image = [YLGIFImage imageWithContentsOfFile:stickerMsg.localPath];
            self.staticPic.hidden = YES;
            self.thumbnailView.hidden = NO;
            [self.thumbnailView layoutIfNeeded];
        } else {
            self.staticPic.image = [UIImage imageWithContentsOfFile:stickerMsg.localPath];
            [self.bubbleView bringSubviewToFront:self.staticPic];
            self.staticPic.frame = self.thumbnailView.frame;
            self.staticPic.hidden = NO;
        }
    } else {
        self.thumbnailView.hidden = YES;
    }
    self.bubbleView.image = nil;
}

- (UIImageView *)thumbnailView {
    if (!_thumbnailView) {
        _thumbnailView = [[YLImageView alloc] init];
        [self.bubbleView addSubview:_thumbnailView];
    }
    return _thumbnailView;
}
- (UIImageView *)staticPic {
    if (!_staticPic) {
        _staticPic = [[UIImageView alloc] init];
        [self.bubbleView addSubview:_staticPic];
    }
    return _staticPic;
}
@end
