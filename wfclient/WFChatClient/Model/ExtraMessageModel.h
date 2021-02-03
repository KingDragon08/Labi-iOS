//
//  ExtraMessageModel.h
//  WFChatClient
//
//  Created by shangguan on 2019/11/29.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExtraMessageModel : NSObject

@property (nonatomic, copy) NSString * money;
@property (nonatomic, copy) NSString * note;
@property (nonatomic, copy) NSString * redPId;
/// 1-转账 2-单个红包 3-群组红包
@property (nonatomic, assign) NSInteger type;
/// 0-普通状态 1-已经接收状态 2-过期未接收状态
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *extra;
@property (nonatomic, assign) BOOL hasAccept;
@property (nonatomic, assign) long long messageUid;
/**
 目标用户ID
 */
@property (nonatomic, copy) NSString *targetId;
@property (nonatomic, copy) NSString *targetName;

@property (nonatomic, copy) NSString *senderId;
@property (nonatomic, copy) NSString *senderName;

+ (ExtraMessageModel *)messageWithJson:(NSString *) json;

@end

NS_ASSUME_NONNULL_END
