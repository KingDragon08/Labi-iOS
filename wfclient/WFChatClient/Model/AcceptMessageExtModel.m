//
//  AcceptMessageExtModel.m
//  WFChatClient
//
//  Created by shangguan on 2019/11/27.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import "AcceptMessageExtModel.h"

@implementation AcceptMessageExtModel

+ (AcceptMessageExtModel *)messageWithJson:(NSString *) json {
    NSDictionary *dic = [self dicWithJson:json];
    return [AcceptMessageExtModel mj_objectWithKeyValues:dic];
}

- (NSString *)jsonWithMessage {
    return self.mj_JSONString;
}

+ (NSDictionary *)dicWithJson:(NSString *)jsonString {
    if (jsonString == nil) {
        return @{};
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        return @{};
    }
    return dic;
}

@end
