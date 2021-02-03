//
//  WFCCTextMessageContent.m
//  WFChatClient
//
//  Created by heavyrain on 2017/8/16.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#import "WFCCCallStartMessageContent.h"
#import "WFCCIMService.h"
#import "Common.h"


@implementation WFCCCallStartMessageContent
- (WFCCMessagePayload *)encode {
    WFCCMessagePayload *payload = [super encode];
    payload.contentType = [self.class getContentType];
    payload.content = self.callId;
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    if (self.connectTime) {
        [dataDict setObject:@(self.connectTime) forKey:@"c"];
    }
    if (self.endTime) {
        [dataDict setObject:@(self.endTime) forKey:@"e"];
    }
    if (self.status) {
        [dataDict setObject:@(self.status) forKey:@"s"];
    }
    
    [dataDict setObject:self.targetId forKey:@"t"];
    [dataDict setValue:@(self.audioOnly?1:0) forKey:@"a"];
    
    payload.binaryContent = [NSJSONSerialization dataWithJSONObject:dataDict
                                                            options:kNilOptions
                                                              error:nil];
    return payload;
}

- (void)decode:(WFCCMessagePayload *)payload {
    [super decode:payload];
    self.callId = payload.content;
    NSError *__error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:payload.binaryContent
                                                               options:kNilOptions
                                                                 error:&__error];
    if (!__error) {
        self.connectTime = dictionary[@"c"] ? [dictionary[@"c"] longLongValue] : 0;
        self.endTime = dictionary[@"e"] ? [dictionary[@"e"] longLongValue] : 0;
        self.status = dictionary[@"s"] ? [dictionary[@"s"] intValue] : 0;
        self.audioOnly = [dictionary[@"a"] intValue] ? YES : NO;
        self.targetId = dictionary[@"t"];
    }
}

+ (int)getContentType {
    return VOIP_CONTENT_TYPE_START;
}

+ (int)getContentFlags {
    return WFCCPersistFlag_PERSIST;
}

+ (void)load {
    [[WFCCIMService sharedWFCIMService] registerMessageContent:self];
}

- (NSString *)digest:(WFCCMessage *)message {
    if (_audioOnly) {
        return @"[语音通话]";
    } else {
        return @"[视频通话]";
    }
}

- (NSString *)getEndReason {
    /* 结束原因
    WFAVCallEndReason
     0: kWFAVCallEndReasonUnknown,
     1: kWFAVCallEndReasonBusy,
     2: kWFAVCallEndReasonSignalError,
     3: kWFAVCallEndReasonHangup,
     4: kWFAVCallEndReasonMediaError,
     5: kWFAVCallEndReasonRemoteHangup,
     6: kWFAVCallEndReasonOpenCameraFailure,
     7: kWFAVCallEndReasonTimeout,
     8: kWFAVCallEndReasonAcceptByOtherClient
     */
    switch (self.status) {
        case 0:
            return @"通话结束";
        case 1:
            return @"对方忙";
        case 2:
            return @"信号错误";
        case 3:
            return @"通话结束";
        case 4:
            return @"音频错误";
        case 5:
            return @"通话结束";
        case 6:
            return @"通话结束";
        case 7:
            return @"连接失败";
        case 8:
            return @"通话结束";
        default:
            return @"通话结束";
    }
}

@end
