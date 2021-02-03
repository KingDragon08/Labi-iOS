//
//  BindCardViewController.h
//  WildFireChat
//
//  Created by xxx on 2018/12/12.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WFChatClient/WFCChatClient.h>
#import "SDWebImage.h"
#import <WFChatUIKit/WFChatUIKit.h>
#import "WFCSettingTableViewController.h"
#import "WFCSecurityTableViewController.h"
#import "WFCMeTableViewCell.h"
#import "WFCInfoTableViewCell.h"
#import "WFUserModel.h"

typedef void(^BindBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface BindCardViewController : UIViewController
@property (nonatomic, copy) BindBlock block; 
@end

NS_ASSUME_NONNULL_END
