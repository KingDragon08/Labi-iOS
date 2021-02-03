//
//  StartSendLuckyMoneyViewController.h
//  WFChatClient
//
//  Created by xxx on 2019/11/20.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMoneyViewController.h"
#import "ZBLocalized.h"

NS_ASSUME_NONNULL_BEGIN

@interface StartSendLuckyMoneyViewController : BaseMoneyViewController

@property (nonatomic, copy) StartMoneyEndBlock block;
@property (nonatomic,strong) WFCCUserInfo *targetUser;
@property (nonatomic,copy) NSString *userId;

@end

NS_ASSUME_NONNULL_END
