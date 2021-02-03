//
//  AgroupLuckyMoneyMessageContent.m
//  WFChatClient
//
//  Created by shangguan on 2019/11/27.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import "AgroupLuckyMoneyMessageContent.h"
#import "WFCCIMService.h"
#import "Common.h"

@implementation AgroupLuckyMoneyMessageContent

- (WFCCMessagePayload *)encode {
    WFCCMessagePayload *payload = [super encode];
    payload.contentType = [self.class getContentType];
    payload.searchableContent = self.text;
    payload.mentionedType = self.mentionedType;
    payload.mentionedTargets = self.mentionedTargets;
    payload.extra = self.extra;
    payload.content = self.extra;
    return payload;
}

- (void)decode:(WFCCMessagePayload *)payload {
    [super decode:payload];
    self.text = payload.searchableContent;
    self.mentionedType = payload.mentionedType;
    self.mentionedTargets = payload.mentionedTargets;
    self.extra = payload.content;
}

+ (int)getContentType {
    return MESSAGE_CONTENT_TYPE_LUCKYMONEY_AGROUP;
}

+ (int)getContentFlags {
    return WFCCPersistFlag_PERSIST_AND_COUNT;
}


+ (instancetype)contentWith:(NSString *)text {
    AgroupLuckyMoneyMessageContent *content = [[AgroupLuckyMoneyMessageContent alloc] init];
    content.text = text;
    return content;
}

+ (void)load {
    [[WFCCIMService sharedWFCIMService] registerMessageContent:self];
}

- (NSString *)digest:(WFCCMessage *)message {
    return self.text;
}

@end
