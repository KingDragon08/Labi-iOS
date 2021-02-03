//
//  BetsModel.m
//  WildFireChat
//
//  Created by xxx on 2018/12/15.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "BetsModel.h"

@implementation BetsModel
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

- (NSString *)betStr {
    return [NSString stringWithFormat:@"%.2f", _bet/100.0];
}

- (NSString *)bondsStr {
    return [NSString stringWithFormat:@"%.2f", _bonus/100.0];
}

- (NSString *)winStr {
    return [NSString stringWithFormat:@"%.2f", _win/100.0];
}

@end
