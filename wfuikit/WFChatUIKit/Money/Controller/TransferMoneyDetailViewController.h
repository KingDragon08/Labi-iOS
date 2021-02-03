//
//  TransferMoneyDetailViewController.h
//  WFChatUIKit
//
//  Created by xxx on 2019/11/20.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMoneyViewController.h"
#import "ZBLocalized.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^AcceptDoneBlock)(void);
@interface TransferMoneyDetailViewController : BaseMoneyViewController

@property (nonatomic, strong)WFCCMessage *message;
@property (nonatomic, copy) NSString *redPId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) BOOL isSender;
@property (nonatomic, copy) AcceptDoneBlock accept;

@end

NS_ASSUME_NONNULL_END
