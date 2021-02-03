//
//  TextCell.m
//  WFChat UIKit
//
//  Created by WF Chat on 2017/9/1.
//  Copyright © 2017年 WildFireChat. All rights reserved.
// 文本

#import "WFCUTextCell.h"
#import <WFChatClient/WFCChatClient.h>
#import "WFCUUtilities.h"
#import "AttributedLabel.h"

#define TEXT_LABEL_TOP_PADDING 3
#define TEXT_LABEL_BUTTOM_PADDING 5
#define TEXT_FONT ([UIFont systemFontOfSize:17.f])
@interface WFCUTextCell () <AttributedLabelDelegate>

@end

@implementation WFCUTextCell
+ (CGSize)sizeForClientArea:(WFCUMessageModel *)msgModel withViewWidth:(CGFloat)width {
  WFCCTextMessageContent *txtContent = (WFCCTextMessageContent *)msgModel.message.content;
    CGSize size = [WFCUUtilities getTextDrawingSize:txtContent.text font:TEXT_FONT constrainedSize:CGSizeMake(width, 8000)];
    size.height += TEXT_LABEL_TOP_PADDING + TEXT_LABEL_BUTTOM_PADDING;
    if (size.width < 40) {
        size.width += 4;
        if (size.width > 40) {
            size.width = 40;
        } else if (size.width < 24) {
            size.width = 24;
        }
    }
  return size;
}

- (void)setModel:(WFCUMessageModel *)model {
  [super setModel:model];
    
  WFCCTextMessageContent *txtContent = (WFCCTextMessageContent *)model.message.content;
    CGRect frame = self.contentArea.bounds;
  self.textLabel.frame = CGRectMake(0, TEXT_LABEL_TOP_PADDING, frame.size.width, frame.size.height - TEXT_LABEL_TOP_PADDING - TEXT_LABEL_BUTTOM_PADDING);
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    [self.textLabel setText:txtContent.text];
//    if (model.message.content.extra == @"100") {
//        model.message.content.extra = @"00009";
//        [[WFCCIMService sharedWFCIMService] updateMessage:model.message.messageId content:model.message.content];
//    }
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
//        _textLabel = [[AttributedLabel alloc] init];
//        ((AttributedLabel*)_textLabel).attributedLabelDelegate = self;
        _textLabel.numberOfLines = 0;
        _textLabel.font = TEXT_FONT;
        _textLabel.userInteractionEnabled = YES;
        [self.contentArea addSubview:_textLabel];
        _textLabel.textColor = UIColor.blackColor;
    }
    return _textLabel;
}

#pragma mark - AttributedLabelDelegate
- (void)didSelectUrl:(NSString *)urlString {
    [self.delegate didSelectUrl:self withModel:self.model withUrl:urlString];
}
- (void)didSelectPhoneNumber:(NSString *)phoneNumberString {
    [self.delegate didSelectPhoneNumber:self withModel:self.model withPhoneNumber:phoneNumberString];
}
@end
