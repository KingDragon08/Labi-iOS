//
//  LuckyMoneyAcceptMessageContent.m
//  WFChatClient
//
//  Created by shangguan on 2019/11/27.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import "LuckyMoneyAcceptMessageContent.h"
#import "WFCCIMService.h"
#import "AcceptMessageExtModel.h"
#import "Common.h"

@implementation LuckyMoneyAcceptMessageContent

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

- (NSString *)getContentFromMessage:(WFCCMessage *)message {
    return @"";
    NSString *textContent;
    AcceptMessageExtModel *amodel = [AcceptMessageExtModel messageWithJson:message.content.extra];
    if ([amodel.senderId isEqualToString:amodel.targetId]) {
        return @"你领取了自己发的";
    }
    if (message.direction == MessageDirection_Send) {
        textContent = [NSString stringWithFormat:@"你领取了%@的",amodel.targetName];
    } else if (message.direction == MessageDirection_Receive) {
        textContent = [NSString stringWithFormat:@"%@领取了你的",amodel.senderName];
    }
    return textContent;
}

+ (int)getContentType {
    return MESSAGE_CONTENT_TYPE_LUCKYMONEY_ACCEPT_SINGLE;
}

+ (int)getContentFlags {
    return WFCCPersistFlag_PERSIST_AND_COUNT;
}


+ (instancetype)contentWith:(NSString *)text {
    LuckyMoneyAcceptMessageContent *content = [[LuckyMoneyAcceptMessageContent alloc] init];
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
