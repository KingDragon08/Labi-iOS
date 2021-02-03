//
//  AcceptMessageFilter.m
//  WFChatClient
//
//  Created by shangguan on 2019/11/29.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import "AcceptMessageFilter.h"
#import "AgroupLuckyMoneyAcceptMessageContent.h"
#import "WFCCIMService.h"
#import "AcceptMessageExtModel.h"
#import "Common.h"

@interface AcceptMessageFilter () <ReceiveMessageFilter>

@end

@implementation AcceptMessageFilter

+ (instancetype)sharedInstance
{
    static AcceptMessageFilter *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (BOOL)onReceiveMessage:(WFCCMessage *)message {
    if ([message.content isKindOfClass:[AgroupLuckyMoneyAcceptMessageContent class]]) {
        AcceptMessageExtModel *aModel = [AcceptMessageExtModel messageWithJson:message.content.extra];
        if ([aModel.targetId isEqualToString:[[WFCCNetworkService sharedInstance] userId]]) {
//            return NO;
        }
    }
    
    return YES;
}

@end
