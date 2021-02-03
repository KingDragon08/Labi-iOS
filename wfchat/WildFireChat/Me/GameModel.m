//
//  GameModel.m
//  WildFireChat
//
//  Created by xxx on 2018/12/15.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel

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

- (NSString *)bstr {
    if (_bankerBonus == -1) {
        return LocalizedString(@"tb");
    }
    return [NSString stringWithFormat:@"%.2f", _bankerBonus/100.0];
}

- (NSString *)bankerWinStr {
    if (_bankerWin) {
        return [NSString stringWithFormat:@"%.2f", _bankerWin.intValue/100.0];
    }
    return @"";
}

@end
