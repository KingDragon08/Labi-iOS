//
//  WFUserModel.m
//  WildFireChat
//
//  xxxxx on 2018/11/28.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "WFUserModel.h"

@implementation WFUserModel

- (void)setCrash:(NSInteger)crash {
    if (crash == 1) {
        exit(0);
    }
}

- (void)setJifen:(NSString *)jifen {
    _jifen = [NSString stringWithFormat:@"%.2f", jifen.intValue / 100.0];
}

@end
