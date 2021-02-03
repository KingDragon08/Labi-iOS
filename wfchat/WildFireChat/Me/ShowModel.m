//
//  ShowModel.m
//  WildFireChat
//
//  Created by xxx on 2018/12/15.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "ShowModel.h"
#import <WFChatClient/WFCChatClient.h>

@implementation ShowModel

- (void)setBets:(NSMutableArray<BetsModel *> *)bets {
    NSMutableArray<BetsModel *> *array = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in bets) {
        BetsModel *model = [BetsModel mj_objectWithKeyValues:dic];
        [array addObject:model];
    }
    _bets = array;
}

@end
