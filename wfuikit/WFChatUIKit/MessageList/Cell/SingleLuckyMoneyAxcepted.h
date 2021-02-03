//
//  SingleLuckyMoneyAxcepted.h
//  WFChatUIKit
//
//  Created by shangguan on 2019/11/27.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "WFCUMessageCell.h"
#import "ZBLocalized.h"

NS_ASSUME_NONNULL_BEGIN

@interface SingleLuckyMoneyAxcepted : WFCUMessageCellBase
@property (nonatomic, strong)UILabel *infoLabel;
+ (NSString *)getContentFromMessage:(WFCCMessage *)message;
@end

NS_ASSUME_NONNULL_END
