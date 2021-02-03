//
//  BaseResponseModel.m
//  WildFireChat
//
//  Created by xxx on 2019/11/14.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import "BaseResponseModel.h"

@implementation BaseResponseModel

- (BOOL)isSuccess {
    if ((self.status != nil) && (self.status == @"0" || ([self.status intValue] == 0))) {
        return YES;
    }
    return NO;
}

@end
