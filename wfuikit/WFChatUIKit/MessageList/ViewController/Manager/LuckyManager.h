//
//  LuckyManager.h
//  WFChatUIKit
//
//  Created by shangguan on 2019/11/27.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFCUMessageModel.h"
#import "NetworkAPI.h"
#import "OpenLuckMoneyView.h"
#import "MessageContentModel.h"
#import "WFCUMessageListViewController.h"
#import "ZBLocalized.h"
#import "NewLunckyMoneyView.h"

NS_ASSUME_NONNULL_BEGIN
@class WFCCConversation;
@interface LuckyManager : NSObject

@property (nonatomic, copy) NSString *redPId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, weak) WFCUMessageListViewController *vc;
@property (nonatomic, strong)WFCCMessage *message;
@property (nonatomic, strong)WFCCConversation *conversation;

- (void)showLuckyMoneyMessage;
+ (BOOL)filterMessage:(WFCCMessage *)message;
/// 收到消息处理
+ (void)receivedMessage:(WFCCMessage *)message;
/// 更新转账消息为已经过期
+ (void)updateTransferMessageHasOutofTime:(WFCCMessage *)message;

/// 发红包更新已经收到的消息--为点击红包或者转账之后的状态修改
+ (void)updateReceiveMessage:(NSArray <WFCCMessage*>*)messages;
/// 是否过滤掉群组中g非自己发送的抢红包消息
+ (BOOL)showTheMessageInCurrent:(WFCCMessage *)messages;

- (void)single_updateMessage:(WFCCMessage *_Nullable)message status:(NSInteger)status;
- (void)single_insertAcceptMessage:(WFCCMessage *_Nullable)message status:(NSInteger)status;
- (void)agroup_updateMessage:(WFCCMessage *_Nullable)message status:(NSInteger)status;
- (void)agroup_insertAcceptMessage:(WFCCMessage *_Nullable)message status:(NSInteger)status;
@end

NS_ASSUME_NONNULL_END
