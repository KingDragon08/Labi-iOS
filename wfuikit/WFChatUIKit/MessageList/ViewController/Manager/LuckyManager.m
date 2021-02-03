//
//  LuckyManager.m
//  WFChatUIKit
//
//  Created by shangguan on 2019/11/27.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "LuckyManager.h"
#import "UserInfo.h"
#import "LuckyMoneyDetailViewController.h"

@interface LuckyManager ()

@end

@implementation LuckyManager {
    
}

- (void)dealloc
{
    NSLog(@"LuckyManager____dealloc");
}

- (void)showLuckyMoneyMessage {
     MessageContentModel *content = [MessageContentModel messageWithJson:self.message.content.extra];
    if ((self.conversation.type == Single_Type) && (self.message.direction == MessageDirection_Send)) {
        if (self.message.direction == MessageDirection_Send) {
            /// 单发发送者直接进入红包详情
            LuckyMoneyDetailViewController *lvc = [[LuckyMoneyDetailViewController alloc] init];
            lvc.redPId = content.redPId;
            lvc.isGroup = NO;
            lvc.conversationId = self.message.conversation.target;
            [self.vc.navigationController pushViewController:lvc animated:YES];
            return;
        }
    }
    
    MessageContentModel *model = [MessageContentModel findMessage:self.message.messageUid];
    if (model != nil) {
        
        NewLunckyMoneyView *open = [NewLunckyMoneyView showBgWithMessage:self.message status:model.status];
        [open setValue:self forKey:@"lManager"];
        return;
    }
    
    [ToastManager showText:@"" inView:self.vc.view];
    NSDictionary *param = @{@"userId":self.userId,@"redPId":content.redPId};
    [[NetworkAPI sharedInstance] getWithUrl:MONEY_LUCKYMONEY_STATUS params:param successComplection:^(NSDictionary * _Nonnull done) {
        NSString *str = [NSString stringWithFormat:@"%@",done[@"data"][@"status"]];
        NSInteger status = [str integerValue];
        NewLunckyMoneyView *open = [NewLunckyMoneyView showBgWithMessage:self.message status:status];
        [open setValue:self forKey:@"lManager"];
    } failureComplection:^(NSDictionary * _Nonnull done) {
        [ToastManager showToast:done[@"msg"] inView:self.vc.view];
    }];
}


- (void)updateMessage:(NSString *)messageUid {
    long long uid = [messageUid longLongValue];
    WFCCMessage *message = [[WFCCIMService sharedWFCIMService] getMessageByUid:uid];
}

// MARK:过滤接受到的红包消息，消息发送
+ (BOOL)filterMessage:(WFCCMessage *)message {
    if ([message.content isKindOfClass:[AgroupLuckyMoneyAcceptMessageContent class]] && message.direction == MessageDirection_Receive) {
        MessageContentModel *mContent = [MessageContentModel messageWithJson:message.content.extra];
        if ([mContent.targetId isEqualToString:[[WFCCNetworkService sharedInstance] userId]] == false) {
            return YES;
        }
    }
    return NO;
}

// MARK: 单独发送红包或者转账消息人接收到对方已经成功领取的消息，更新本地的数据
+ (void)updateReceiveMessage:(NSArray <WFCCMessage*>*)messages {
    for (WFCCMessage *message in messages) {
        if (message.direction == MessageDirection_Send) { return; }
        if (message.conversation.type == Single_Type && ([message.content isKindOfClass:[TransferMoneyAcceptModel class]]||[message.content isKindOfClass:[LuckyMoneyAcceptMessageContent class]])) {
            @autoreleasepool {
                /// 更新发送方本地消息 tansfer 接收到accept 消息
                MessageContentModel *m = [MessageContentModel messageWithJson:message.content.extra];
                [MessageContentModel insertMessage:m];
            }
        }
    }
}

+ (void)receivedMessage:(WFCCMessage *)message {
    
}

// MARK: OPenLuckMoneyDelegate 代理

- (void) single_updateMessage:(WFCCMessage *)message status:(NSInteger)status {
    MessageContentModel *m = [MessageContentModel messageWithJson:message.content.extra];
    /// 10-本人已经领取成功过了已经领取,客户端定义消息类型
    m.status = status;
    m.messageUid = message.messageUid;
    if (self.conversation == Single_Type) {
        m.type = MONEY_SINGLE;
    } else {
        if (status == MONEY_STATE_SERVER_ROBED) {
            m.status = MONEY_STATE_HAS_ROBED;
        }
        m.type = MONEY_AGROUP;
    }
    [MessageContentModel insertMessage:m];
}

- (void)single_insertAcceptMessage:(WFCCMessage *)message status:(NSInteger)status {
    MessageContentModel *content = [MessageContentModel messageWithJson:message.content.extra];
    /// 10-本人已经领取成功需要发送已经领取消息,客户端定义消息类型
    WFCCUserInfo * targetUser = [[WFCCIMService sharedWFCIMService] getUserInfo:message.fromUser refresh:NO];
    WFCCUserInfo *senderUser = [[WFCCIMService sharedWFCIMService] getUserInfo:[UserInfo sharedInstance].userId refresh:NO];
    
    content.status = status;
    if (message.conversation.type != Single_Type) {
        if (targetUser.friendAlias.length > 0) {
            content.targetName = targetUser.friendAlias;
        } else if(targetUser.groupAlias.length > 0) {
            content.targetName = targetUser.groupAlias;
        } else if (targetUser.displayName.length > 0) {
            content.targetName = targetUser.displayName;
        } else {
            content.targetName = targetUser.name;
        }
    } else {
        if(targetUser.friendAlias.length) {
            content.targetName = targetUser.friendAlias;
        } else if (targetUser.displayName.length > 0) {
            content.targetName = targetUser.displayName;
        } else {
            content.targetName = targetUser.name;
        }
    }
    
    content.messageUid = message.messageUid;
    content.targetId = message.fromUser;
    content.senderId = senderUser.userId;
    
    NSString *senderName = senderUser.displayName;
    if(targetUser.friendAlias.length) {
        senderName = senderUser.friendAlias;
    }
    content.senderName = senderName;
    ///一对一
    if (self.conversation.type == Single_Type) {
        content.type = MONEY_SINGLE;
    } else {
        content.type = MONEY_AGROUP;
    }
    [self.vc acceptLuckyMoneySuccess:content.jsonWithMessage];
}

/**
 更新本地的消息状态

 @param message 消息
 @param status 状态
 */
- (void)agroup_updateMessage:(WFCCMessage *)message status:(NSInteger)status {
    MessageContentModel *m = [MessageContentModel messageWithJson:message.content.extra];
    /// 10-本人已经领取成功过了已经领取,客户端定义消息类型
    m.status = status;
    m.messageUid = message.messageUid;
    if (self.conversation == Single_Type) {
        m.type = MONEY_SINGLE;
    } else {
        m.type = MONEY_AGROUP;
    }
    [MessageContentModel insertMessage:m];
}

/**
 抢过群组红包需要发送消息

 @param message 点击的消息
 @param status 本地消息存储状态
 */
- (void)agroup_insertAcceptMessage:(WFCCMessage *)message status:(NSInteger)status {
    MessageContentModel *content = [MessageContentModel messageWithJson:message.content.extra];
    /// 10-本人已经领取成功需要发送已经领取消息,客户端定义消息类型
    WFCCUserInfo * targetUser = [[WFCCIMService sharedWFCIMService] getUserInfo:message.fromUser refresh:NO];
    WFCCUserInfo *senderUser = [[WFCCIMService sharedWFCIMService] getUserInfo:[UserInfo sharedInstance].userId refresh:NO];
    content.status = status;
    content.messageUid = message.messageUid;
    content.targetId = message.fromUser;
    content.targetName = targetUser.name;
    content.senderId = senderUser.userId;
    content.senderName = senderUser.name;
    /// 群组
    content.type = MONEY_AGROUP;
    [self.vc acceptLuckyMoneySuccess:content.jsonWithMessage];
}

/**
 转账已过期
 @param message
 */
+ (void)updateTransferMessageHasOutofTime:(WFCCMessage *)message {
    MessageContentModel *m = [MessageContentModel messageWithJson:message.content.extra];
    /// 已经领取
    m.status = MONEY_STATE_HAS_ROBED;
    m.messageUid = message.messageUid;
    [MessageContentModel insertMessage:m];
}

+ (BOOL)showTheMessageInCurrent:(WFCCMessage *)messages {
    return NO;
}


@end
