//
//  ToastManager.h
//  WFChatUIKit
//
//  Created by xxx on 2019/11/20.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+Toast.h"
#import "ZBLocalized.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToastManager : NSObject

+ (void)showText:(NSString *) text inView:(UIView *)showView;
+ (void)hiddenHud;
+ (void)showToast:(NSString *) text inView:(UIView *)showView;

@end

NS_ASSUME_NONNULL_END
