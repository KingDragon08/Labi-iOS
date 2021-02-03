//
//  OpenLuckMoneyView.h
//  ShowAnimation
//
//  Created by shangguan on 2019/11/21.
//  Copyright © 2019 shangguan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LuckyManager.h"
#import "LuckyMoneyListModel.h"
#import "ZBLocalized.h"

NS_ASSUME_NONNULL_BEGIN

@interface OpenLuckMoneyView : UIView

//+ (void)showBgWithDelegate:(id <OPenLuckMoneyDelegate>)delegate Message:(WFCCMessage *)message status:(NSInteger)status;
+ (OpenLuckMoneyView *)showBgWithMessage:(WFCCMessage *)message status:(NSInteger)status;
//- (instancetype) initWithMessage:(WFCCMessage *) message status:(NSInteger)status delegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END
