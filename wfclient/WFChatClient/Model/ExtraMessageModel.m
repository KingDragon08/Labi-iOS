//
//  ExtraMessageModel.m
//  WFChatClient
//
//  Created by shangguan on 2019/11/29.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import "ExtraMessageModel.h"
#import "MJExtension.h"

@implementation ExtraMessageModel

+ (ExtraMessageModel *)messageWithJson:(NSString *) json {
    NSDictionary *dic;
    if (json == nil) {
        dic = @{};
    }
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        dic = @{};
    }
    return [ExtraMessageModel mj_objectWithKeyValues:dic];
}

@end
