//
//  AcceptMessageExtModel.h
//  WFChatClient
//
//  Created by shangguan on 2019/11/27.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
NS_ASSUME_NONNULL_BEGIN

@interface AcceptMessageExtModel : NSObject

/**
 redBag ID
 */
@property (nonatomic, copy) NSString *redPId;

/**
 发送消息人ID
 */
@property (nonatomic, copy) NSString *senderId;

@property (nonatomic, copy) NSString *senderName;

/**
 目标人ID
 */
@property (nonatomic, copy) NSString *targetId;
@property (nonatomic, copy) NSString *targetName;

/**
 保留字段
 */
@property (nonatomic, copy) NSString *extra;

+ (AcceptMessageExtModel *)messageWithJson:(NSString *) json;
- (NSString *)jsonWithMessage;

@end

NS_ASSUME_NONNULL_END
