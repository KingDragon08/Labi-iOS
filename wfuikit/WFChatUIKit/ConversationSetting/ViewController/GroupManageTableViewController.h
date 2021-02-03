//
//  GroupManageTableViewController.h
//  WFChatUIKit
//
//  Created by heavyrain lee on 2019/6/26.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WFChatClient/WFCChatClient.h>
#import "ZBLocalized.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupManageTableViewController : UIViewController
@property (nonatomic, strong)WFCCGroupInfo *groupInfo;
@end

NS_ASSUME_NONNULL_END
