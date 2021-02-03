//
//  MessageContentModel.m
//  WFChatUIKit
//
//  Created by xxx on 2019/11/19.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "MessageContentModel.h"
#import "WFCUUtilities.h"
#import "BGFMDB.h"

#define M_TAB(x) ([NSString stringWithFormat:@"DB%@",x])

@implementation MessageContentModel


- (NSString *)moneyYuan {
    return [NSString stringWithFormat:@"%.2f",[self.money doubleValue]/100];
}
+ (NSArray *)bg_uniqueKeys {
    return @[@"messageUid"];
}

+ (MessageContentModel *)messageWithJson:(NSString *) json {
    NSDictionary *dic = [WFCUUtilities dicWithJson:json];
    return [MessageContentModel mj_objectWithKeyValues:dic];
}

- (NSString *)jsonWithMessage {
    return self.mj_JSONString;
}

+ (void)insertMessage:(MessageContentModel *)message {
    NSString *trimmedString = [[WFCCNetworkService sharedInstance].userId stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[ _`~!@#$%-^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]|\n|\r|\t"]];
    message.bg_tableName = M_TAB(trimmedString);
    if (!message.messageUid) {
        return;
    }
    NSString *conditions = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"messageUid"),bg_sqlValue([NSNumber numberWithLongLong:message.messageUid])];
    NSArray *searchArray = [MessageContentModel bg_find:M_TAB(trimmedString) where:conditions];
    if (searchArray.count > 0) {
        [message bg_updateWhere:conditions];
    } else {
        if ([message bg_save]) {
            NSLog(@"Save________success");
        } else {
            NSLog(@"Save________failure");
        }
    }
}

+ (MessageContentModel *)findMessage:(long long)mId{
    NSString *trimmedString = [[WFCCNetworkService sharedInstance].userId stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[ _`~!@#$%-^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]|\n|\r|\t"]];
    NSString *conditions = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"messageUid"),bg_sqlValue([NSNumber numberWithLongLong:mId])];
    NSArray <MessageContentModel *> *messages = [MessageContentModel bg_find:M_TAB(trimmedString) where:conditions];
    if (messages.count > 0) {
        return [messages firstObject];
    } else {
        return nil;
    }
}

@end
