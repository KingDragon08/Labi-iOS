//
//  AcceptMessageFilter.h
//  WFChatClient
//
//  Created by shangguan on 2019/11/29.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "WFCCNetworkService.h"
NS_ASSUME_NONNULL_BEGIN

@interface AcceptMessageFilter : NSObject
/**
 返回网络请求单例
 @return 网络请求单例
 */
+ (instancetype)sharedInstance;
@end

NS_ASSUME_NONNULL_END
