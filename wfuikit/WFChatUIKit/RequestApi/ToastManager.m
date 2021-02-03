//
//  ToastManager.m
//  WFChatUIKit
//
//  Created by xxx on 2019/11/20.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "ToastManager.h"
#import "MBProgressHUD.h"

@interface ToastManager ()

@property (nonatomic, strong) NSMutableArray <MBProgressHUD *>*views;

@end

@implementation ToastManager

+ (instancetype)sharedInstance
{
    static ToastManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.views = [NSMutableArray arrayWithCapacity:3];
    });
    return instance;
}

/**
 网络加载动画

 @param text 显示加载类型
 @param showView superView
 */
+ (void)showText:(NSString *) text inView:(UIView *)showView {
    [[ToastManager sharedInstance] showText:text inView:showView];
}

/**
 显示Toast
 @param text toast内容
 @param showView 展示SuperView
 */
+ (void)showToast:(NSString *) text inView:(UIView *)showView {
    [[ToastManager sharedInstance] showToast:text inView:showView];
}

+ (void)hiddenHud{
    [[ToastManager sharedInstance] hiddenHud];
}

- (void)showText:(NSString *) text inView:(UIView *)showView {
    if (self.views.count > 0) {
        for (MBProgressHUD *h in self.views) {
            [h hideAnimated:NO];
        }
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
    hud.label.text = text;
    [hud showAnimated:YES];
    [self.views addObject:hud];
}

- (void)showToast:(NSString *) text inView:(UIView *)showView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.offset = CGPointMake(0.f, 0);
    [hud hideAnimated:YES afterDelay:1.f];
}

- (void)hiddenHud {
    if (self.views.count > 0) {
        for (MBProgressHUD *h in self.views) {
            [h hideAnimated:YES];
        }
    }
}

@end
