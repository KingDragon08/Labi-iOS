//
//  MessageContentModel.h
//  WFChatUIKit
//
//  Created by xxx on 2019/11/19.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    /// 初始状态
    MONEY_STATE_NORMAL = 0,
    /// 已经抢到--10
    MONEY_STATE_HAS_ROBED = 10,
    /// 已经抢完--1001
    MONEY_STATE_HAS_GONE = 1001,
    /// 已经过期--1002
    MONEY_STATE_OUTOFTIME = 1002,
    /// 其他状态
    MONEY_STATE_SERVER_ROBED = 1004,
} MONEY_STATE;

typedef enum : NSUInteger {
    /// 转账--1
    MONEY_TRANSFER = 1,
    /// 单发红包--2
    MONEY_SINGLE = 2,
    /// 群发红包--3
    MONEY_AGROUP = 3,
} MONEY_STYLE;

typedef enum : NSUInteger {
    /// 未接受 -- 0
    TRANSFER_NORMAL = 0,
    /// 已接受 -- 1
    TRANSFER_HASACCEPT = 1,
    /// 已过期 -- 2
    TRANSFER_OUTOFTIME = 2,
} TRANSFER_STATUS;

@interface MessageContentModel : NSObject

/**
 统一存储成为分
 */

/**
 money-单位分
 */
@property (nonatomic, copy) NSString * money;
/**
 备注信息
 */
@property (nonatomic, copy) NSString * note;
/**
 红包OR转账 id
 */
@property (nonatomic, copy) NSString * redPId;
/// 1-转账 2-单个红包 3-群组红包
@property (nonatomic, assign) NSInteger type;
/// 0-普通状态 1-已经接收状态 2-过期未接收状态
@property (nonatomic, assign) NSInteger status;
/**
 额外信息-暂时无用c
 */
@property (nonatomic, copy) NSString *extra;
/**
 点击的消息UID，eg：点击领取红包，则为红包的UId
 */
@property (nonatomic, assign) long long messageUid;
/**
 目标用户ID
 */
@property (nonatomic, copy) NSString *targetId;
/**
 目标用户name（无备注则显示昵称）
 */
@property (nonatomic, copy) NSString *targetName;
/**
 发送消息人 id
 */
@property (nonatomic, copy) NSString *senderId;
/**
 发送消息人 名称
 */
@property (nonatomic, copy) NSString *senderName;


+ (MessageContentModel *)messageWithJson:(NSString *) json;
- (NSString *)jsonWithMessage;
- (NSString *)moneyYuan;
/**
 插入或者更新数据primaryKey 为 messageUid
 @param message 需要存储的消息对应的extra
 */
+ (void)insertMessage:(MessageContentModel *)message;

/**
 根据Uid查找到相应的message对应的MessageContent中ertra对应的字段的model值
 @param mId messageUId
 @return 返回的格式化MessageContentModel
 */
+ (MessageContentModel *)findMessage:(long long)mId;

@end

NS_ASSUME_NONNULL_END
