//
//  ContactListViewController.h
//  WFChatUIKit
//
//  Created by shangguan on 2019/11/26.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMoneyViewController.h"
#import "ContactListCell.h"
#import "ZBLocalized.h"

#import "StartSendGroupLuckyMoneyController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ContactListViewController : BaseMoneyViewController

@property (nonatomic, copy) NSString *agroupId;
@property (nonatomic, weak) StartSendGroupLuckyMoneyController *cv;
@property (nonatomic, strong) NSMutableSet <NSString*>*selects;

@end

NS_ASSUME_NONNULL_END
