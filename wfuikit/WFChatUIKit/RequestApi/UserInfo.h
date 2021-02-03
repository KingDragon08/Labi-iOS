//
//  UserInfo.h
//  WFChatUIKit
//
//  Created by shangguan on 2019/11/27.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    WALLET_OTHERCODE= 1000,
    CREATE_WALLET = 1001,
    HAS_WALLET = 0,
} WalletStatus;

typedef void(^ResultlBlock)(NSDictionary *done);
NS_ASSUME_NONNULL_BEGIN

@interface UserInfo : NSObject

@property (nonatomic, assign) BOOL hasWallet;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *money;

@property (nonatomic, assign, getter=isSlient) BOOL slient;

+ (UserInfo *)sharedInstance;

- (void)updateWallet;
- (void)updateWallet:(ResultlBlock )block;

- (NSString *)getMoneyStr;


@end

NS_ASSUME_NONNULL_END
