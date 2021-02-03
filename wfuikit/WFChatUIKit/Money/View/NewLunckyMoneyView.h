//
//  NewLunckyMoneyView.h
//  WFChatUIKit
//
//  xxxxx on 2018/11/22.
//  Copyright © 2018 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LuckyManager.h"
#import "LuckyMoneyListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NewLunckyMoneyView : UIView
+ (NewLunckyMoneyView *)showBgWithMessage:(WFCCMessage *)message status:(NSInteger)status;
+ (void)showLuckyMoney;
- (void)showBg;
@end

NS_ASSUME_NONNULL_END
