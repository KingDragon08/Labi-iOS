//
//  WFRegisterManager.m
//  WildFireChat
//
//  Created by xxxty on 2018/2/25.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "WFRegisterManager.h"
#import <WFChatUIKit/WFChatUIKit.h>

@implementation WFRegisterManager

- (BOOL)accountCanuse:(NSString *)account {
    NSString *regEx = @"^[A-Za-z0-9]{4,16}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    return [predicate evaluateWithObject:account];
}

- (BOOL)passportCanuse:(NSString *)password {
    NSString *regEx = @"^[A-Za-z0-9]{6,16}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    return [predicate evaluateWithObject:password];
}

- (void)registerAUserBy:(NSString *)count andPassword:(NSString *)password success:(SuccessBLock )success failureComplection: (FailureBLock)failure {
    NSDictionary *param = @{@"name": count,
                            @"password": password
    };
    [[NetworkAPI sharedInstance] postWithUrl:REGISTER_BY_ACCOUNT params:param successComplection:success failureComplection:failure];
}

@end
