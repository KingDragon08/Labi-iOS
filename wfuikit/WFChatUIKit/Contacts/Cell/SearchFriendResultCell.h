//
//  SearchFriendResultCell.h
//  WFChatUIKit
//
//    on 2019/11/5.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WFChatClient/WFCChatClient.h>
#import "ZBLocalized.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchFriendResultCell : UITableViewCell

- (void) setUserInfo:(WFCCUserInfo *)info;

@end

NS_ASSUME_NONNULL_END
