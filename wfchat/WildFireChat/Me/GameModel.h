//
//  GameModel.h
//  WildFireChat
//
//  Created by xxx on 2018/12/15.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameModel : NSObject
@property (nonatomic, strong) NSString *created_time;
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *bonusId;
@property (nonatomic, strong) NSString *banker;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, assign) NSInteger bankerBonus;
@property (nonatomic, strong) NSString *bstr;
@property (nonatomic, strong) NSString *bankerWinStr;
@property (nonatomic, strong) NSNumber *bankerWin;

@end

NS_ASSUME_NONNULL_END
