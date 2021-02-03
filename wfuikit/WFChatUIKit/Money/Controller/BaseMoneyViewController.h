//
//  BaseMoneyViewController.h
//  WFChatUIKit
//
//  Created by xxx on 2019/11/20.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentNavigationBar.h"
#import "NetworkAPI.h"
#import "ToastManager.h"
#import <WFChatClient/WFCChatClient.h>
#import "MessageContentModel.h"
#import "InputPasswordView.h"
#import "XWMoneyTextField.h"
#import "LuckyMoneyListModel.h"
#import "ZBLocalized.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^StartMoneyEndBlock)(NSString *content);

@interface BaseMoneyViewController : UIViewController
@property (nonatomic, strong) PresentNavigationBar *bar;
- (void)backCLick;
@end

NS_ASSUME_NONNULL_END
