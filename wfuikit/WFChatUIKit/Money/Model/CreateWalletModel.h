//
//  CreateWalletModel.h
//  WFChatUIKit
//
//  Created by shangguan on 2019/11/26.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface CreateWalletModel : NSObject
/**
"score": 0,
score

"createdAt": "xxx",
createdAt

"money": 0,
money

"id": 1,
id

"userId": "xxx",
userId

"status": 0
 **/
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *createdAt;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *walletId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *status;

@end

NS_ASSUME_NONNULL_END
