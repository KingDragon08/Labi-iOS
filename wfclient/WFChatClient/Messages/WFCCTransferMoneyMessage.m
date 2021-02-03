//
//  WFCCTransferMoneyMessage.m
//  WFChatClient
//
//  Created by xxx on 2019/11/18.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import "WFCCTransferMoneyMessage.h"
#import "WFCCIMService.h"
#import "Common.h"

@implementation WFCCTransferMoneyMessage

- (WFCCMessagePayload *)encode {
    WFCCMessagePayload *payload = [super encode];
    payload.contentType = [self.class getContentType];
    payload.searchableContent = self.text;
    payload.mentionedType = self.mentionedType;
    payload.mentionedTargets = self.mentionedTargets;
    payload.binaryContent = [self.extra dataUsingEncoding:NSUTF8StringEncoding];
//    payload.extra = self.extra;
    payload.content = self.extra;
    return payload;
}

- (void)decode:(WFCCMessagePayload *)payload {
    [super decode:payload];
    self.text = payload.searchableContent;
    self.mentionedType = payload.mentionedType;
    self.mentionedTargets = payload.mentionedTargets;
    self.extra = payload.content;
    self.extra = [[NSString alloc] initWithData:payload.binaryContent encoding:NSUTF8StringEncoding];
}

+ (int)getContentType {
    return MESSAGE_CONTENT_TYPE_TRANSFERMONEY;
}

+ (int)getContentFlags {
    return WFCCPersistFlag_PERSIST_AND_COUNT;
}


+ (instancetype)contentWith:(NSString *)text {
    WFCCTransferMoneyMessage *content = [[WFCCTransferMoneyMessage alloc] init];
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
