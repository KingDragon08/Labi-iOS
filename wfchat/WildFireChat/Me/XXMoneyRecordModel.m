//
//  XXMoneyRecordModel.m
//  WildFireChat
//
//  Created by  on 2020/12/24.
//  Copyright © 2020 WildFireChat. All rights reserved.
//

#import "XXMoneyRecordModel.h"

@implementation XXMoneyRecordModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idStr":@"id"};
}

- (NSString *)created_time {
    NSString *timeStr = _created_time;
    double time = [timeStr doubleValue];
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    //将时间转换为字符串
    NSString *timeS = [formatter stringFromDate:myDate];
    return timeS;
}

- (BOOL)lessZero {
    return _amount.intValue <= 0;
}
- (NSString *)amountStr{
    return [NSString stringWithFormat:@"%.2f", _amount.intValue/100.0];
}

- (NSString *)typeString {
//    NSString *_str;
//    switch (_type) {
//        case 0:
//            _str = @"上分";
//            break;
//        case 1:
//            _str = @"下分";
//            break;
//        case 2:
//            _str = @"游戏输赢";
//            break;
//        case 3:
//            _str = @"红包转积分";
//            break;
//        case 4:
//            _str = @"上分待审核";
//            break;
//        case 5:
//            _str = @"下分待审核";
//            break;
//        case 6:
//            _str = @"红包积分待审核";
//            break;
//    }
//    if (_str) {
//        return _str;
//    }
    
    return [NSString stringWithFormat:@"%@",_type];
}


@end
