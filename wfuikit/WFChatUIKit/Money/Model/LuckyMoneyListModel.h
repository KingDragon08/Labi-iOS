//
//  LuckyMoneyListModel.h
//  WFChatUIKit
//
//  Created by xxx on 2019/11/21.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFChatClient/WFCChatClient.h>
NS_ASSUME_NONNULL_BEGIN

@interface MoneyRecordModel : NSObject

@property (nonatomic, copy) NSString *userId;
/// 手气最佳
@property (nonatomic, assign) BOOL luckyKing;
/// 抢到的money 分
@property (nonatomic, strong) NSNumber *money;
/// 姓名
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *showName;
/// 时间
@property (nonatomic, copy) NSString *createdAt;
/// 头像
@property (nonatomic, copy) NSString *portrait;

@end

@interface LuckyMoneyListModel : NSObject

@property (nonatomic, copy) NSString *createdAt;
/// 总钱数
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *targetUsers;
/// 个数
@property (nonatomic, copy) NSString *number;
/// note 备注
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *redPId;
/// 类型 0-均分 1-随机
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *updatedAt;
@property (nonatomic, strong) NSMutableArray <MoneyRecordModel*>*records;
@property (nonatomic, strong) MoneyRecordModel *mineRecord;

@property (nonatomic, assign) NSInteger robedMoney;

- (NSString *)getMoneyStr;

@end

NS_ASSUME_NONNULL_END
