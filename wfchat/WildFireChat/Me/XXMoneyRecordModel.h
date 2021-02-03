//
//  XXMoneyRecordModel.h
//  WildFireChat
//
//  Created by  on 2020/12/24.
//  Copyright © 2020 WildFireChat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXMoneyRecordModel : NSObject
/// 抢到的money 分
@property (nonatomic, strong) NSNumber *amount;
/// 姓名
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *showName;
@property (nonatomic, copy) NSString *created_time;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *typeString;
@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, strong) NSString *amountStr;

- (BOOL)lessZero;

@end

NS_ASSUME_NONNULL_END
