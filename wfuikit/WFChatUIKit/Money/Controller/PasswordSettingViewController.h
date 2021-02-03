//
//  PasswordSettingViewController.h
//  WFChatUIKit
//
//  Created by shangguan on 2019/11/26.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBLocalized.h"
#import "ZBLocalized.h"

NS_ASSUME_NONNULL_BEGIN

@interface PasswordSettingViewController : UIViewController
@property (nonatomic, assign) BOOL isMakeSure;
@property (nonatomic, copy) NSString *firstPassword;
@property (nonatomic, copy) NSString *userId;
@end

NS_ASSUME_NONNULL_END
