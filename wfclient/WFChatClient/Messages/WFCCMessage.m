//
//  WFCCMessage.m
//  WFChatClient
//
//  Created by heavyrain on 2017/8/16.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#import "WFCCMessage.h"
#import "Common.h"


@implementation WFCCMessage
- (NSString *)digest {
    return [self.content digest:self];
}

- (BOOL) moneyMessageInvalid {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;
    long long tTime = time;
//    24 * 60 * 60 * 1000
    if (tTime - self.serverTime > 24 * 60 * 60 * 1000) {
        return YES;
    }
    return NO;
}
@end
