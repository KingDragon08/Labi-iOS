//
//  UserInfo.m
//  WFChatUIKit
//
//  Created by shangguan on 2019/11/27.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "UserInfo.h"
#import "NetworkAPI.h"
#import <WFChatClient/WFCChatClient.h>

@implementation UserInfo

static UserInfo * sharedSingleton = nil;

+ (UserInfo *)sharedInstance {
    if (sharedSingleton == nil) {
        @synchronized (self) {
            if (sharedSingleton == nil) {
                sharedSingleton = [[UserInfo alloc] init];
            }
        }
    }
    return sharedSingleton;
}

- (void)updateWallet:(ResultlBlock )block {
    if (self.userId != NULL && self.userId.length > 0) {
        [[NetworkAPI sharedInstance] getWithUrl:WALLET_DETAIL params:@{@"userId":self.userId} successComplection:^(NSDictionary * _Nonnull done) {
            NSString *status = [NSString stringWithFormat:@"%@",done[@"data"][@"status"]];
            if (done[@"data"][@"id"] != nil) {
                /// 已经是创建过的
                self.money = [NSString stringWithFormat:@"%@", done[@"data"][@"money"]];
                self.hasWallet = YES;
                block(@{@"hasWallet":@1, @"status":status});
            } else {
                block(@{@"hasWallet":@0, @"status":@1001});
            }
        } failureComplection:^(NSDictionary * _Nonnull done) {
            self.hasWallet = NO;
            if (done[@"status"]) {
                block(@{@"hasWallet":@0, @"status":done[@"status"]});
            } else {
                block(@{@"hasWallet":@0, @"status":@"-1001"});
            }
        }];
    }
}

- (void)updateWallet {
    /**
    "score": 0,
    "createdAt": "xxx",
    "money": 0,
    "id": 1,
    "userId": "xxx",
    "status": 0
    **/
    if (!self.userId) {
        return;
    }
    [[NetworkAPI sharedInstance] getWithUrl:WALLET_DETAIL params:@{@"userId":self.userId} successComplection:^(NSDictionary * _Nonnull done) {
        if ([done[@"data"][@"status"] integerValue] == 0) {
            /// 已经是创建过的
            self.money = [NSString stringWithFormat:@"%@", done[@"data"][@"money"]];
            self.hasWallet = YES;
        } else {
            self.hasWallet = NO;
        }
    } failureComplection:^(NSDictionary * _Nonnull done) {
        if ([done[@"status"] integerValue] == 1) {
            self.hasWallet = NO;
        }
    }];
}

- (NSString *)userId {
    return [WFCCNetworkService sharedInstance].userId;
}

- (NSString *)getMoneyStr {
    if (!self.money) {
        return @"0.00";
    } else {
        return [NSString stringWithFormat:@"%.2f",[self.money doubleValue]/100.0];
    }
}

- (void)setSlient:(BOOL)slient {
    [[NSUserDefaults standardUserDefaults] setBool:slient forKey:@"kSlientState"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (BOOL)isSlient {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"kSlientState"];
}

@end
