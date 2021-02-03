//
//  WFCCLuckMoneyMessage.m
//  WFChatClient
//
//  Created by xxx on 2019/11/14.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import "WFCCLuckMoneyMessage.h"
#import "WFCCIMService.h"
#import "Common.h"

@implementation WFCCLuckMoneyMessage

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
    return MESSAGE_CONTENT_TYPE_LUCKYMONEY;
}

+ (int)getContentFlags {
    return WFCCPersistFlag_PERSIST_AND_COUNT;
}


+ (instancetype)contentWith:(NSString *)text {
    WFCCLuckMoneyMessage *content = [[WFCCLuckMoneyMessage alloc] init];
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
