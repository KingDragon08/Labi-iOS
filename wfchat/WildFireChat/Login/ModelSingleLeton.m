//
//  ModelSingleLeton.m
//  WildFireChat
//
//  Created by xxx on 2018/12/17.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "ModelSingleLeton.h"

@implementation ModelSingleLeton
+ (ModelSingleLeton *)share {
    static ModelSingleLeton *m;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [ModelSingleLeton new];
    });
    return m;
}
@end
