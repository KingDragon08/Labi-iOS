//
//  StartSendGroupLuckyMoneyController.h
//  WFChatUIKit
//
//  Created by xxx on 2019/11/20.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "BaseMoneyViewController.h"
#import "ZBLocalized.h"

NS_ASSUME_NONNULL_BEGIN

@interface StartSendGroupLuckyMoneyController : BaseMoneyViewController
@property (nonatomic, copy) StartMoneyEndBlock block;
@property (nonatomic, strong) WFCCUserInfo *targetUser;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *agroupId;
- (void) updateSelects:(NSMutableSet <NSString*> *)selects;
@end

NS_ASSUME_NONNULL_END
