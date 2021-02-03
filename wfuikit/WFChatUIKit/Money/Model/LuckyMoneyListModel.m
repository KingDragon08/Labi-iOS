//
//  LuckyMoneyListModel.m
//  WFChatUIKit
//
//  Created by xxx on 2019/11/21.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "LuckyMoneyListModel.h"

@implementation MoneyRecordModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
@end

@implementation LuckyMoneyListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"records"]) {
        self.records = [NSMutableArray arrayWithCapacity:5];
        for (NSDictionary *dic in value) {
            MoneyRecordModel *record = [MoneyRecordModel mj_objectWithKeyValues:dic];
            if ([record.userId isEqualToString:[[WFCCNetworkService sharedInstance] userId]]) {
                self.mineRecord = record;
            }
            WFCCUserInfo *target = [[WFCCIMService sharedWFCIMService] getUserInfo:record.userId refresh:NO];
            if (target.friendAlias.length) {
                record.showName = target.friendAlias;
            } else {
                record.showName = target.displayName;
            }
            self.robedMoney = self.robedMoney + record.money.intValue;
            [self.records addObject:record];
        }
    } else {
        [super setValue:value forKey:key];
    }
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"redPId": @"id"};
}

- (NSString *)getMoneyStr {
    if (self.money != nil) {
        NSString *str = [NSString stringWithFormat:@"¥%.2f", [self.money doubleValue] / 100];
        return str;
    }
    return @"";
}
@end
