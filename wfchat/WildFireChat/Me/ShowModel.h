//
//  ShowModel.h
//  WildFireChat
//
//  Created by xxx on 2018/12/15.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameModel.h"
#import "BetsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShowModel : NSObject

@property (nonatomic, strong) GameModel *game;
@property (nonatomic, strong) NSMutableArray <BetsModel*> *bets;
@property (nonatomic, strong) NSString *banker;

@end

NS_ASSUME_NONNULL_END
