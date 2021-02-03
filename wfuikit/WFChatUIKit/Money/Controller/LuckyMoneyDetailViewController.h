//
//  LuckyMoneyDetailViewController.h
//  WFChatUIKit
//
//  Created by xxx on 2019/11/20.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "BaseMoneyViewController.h"
#import "AcceptLuckyMoneyCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface LuckyMoneyDetailViewController : BaseMoneyViewController

@property (nonatomic, copy) NSString *redPId;
@property (nonatomic, copy) NSString *conversationId;
@property (nonatomic, strong) LuckyMoneyListModel *allRecord;
@property (nonatomic, assign) BOOL isGroup;


@end

NS_ASSUME_NONNULL_END
