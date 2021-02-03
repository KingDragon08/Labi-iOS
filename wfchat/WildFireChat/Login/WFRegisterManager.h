//
//  WFRegisterManager.h
//  WildFireChat
//
//  Created by xxxty on 2018/2/25.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFChatUIKit/WFChatUIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface WFRegisterManager : NSObject


/// 校验账号是和符合要求
/// @param account 输入账号
- (BOOL)accountCanuse:(NSString *)account;

/// 校验密码是否符合要求
/// @param passport 输入密码
- (BOOL)passportCanuse:(NSString *)password;

- (void)registerAUserBy:(NSString *)count andPassword:(NSString *)password success:(SuccessBLock )success failureComplection: (FailureBLock)failure;

@end

NS_ASSUME_NONNULL_END
