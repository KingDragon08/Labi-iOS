//
//  ModelSingleLeton.h
//  WildFireChat
//
//  Created by xxx on 2018/12/17.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ModelSingleLeton : NSObject
+ (ModelSingleLeton *)share;
@property (nonatomic, strong) CardModel *cModel;
@end

NS_ASSUME_NONNULL_END
