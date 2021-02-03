//
//  ContactListCell.h
//  WFChatUIKit
//
//  Created by shangguan on 2019/11/26.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WFChatClient/WFCChatClient.h>
#import "SDWebImage.h"
#import "ZBLocalized.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectBlock)(NSString *userId);

@interface ContactListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *stateImage;
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, copy) SelectBlock select;
@property (nonatomic, copy) SelectBlock deSelect;

@property (nonatomic, strong) WFCCUserInfo *userInfo;

- (void)tapSelect;
@end

NS_ASSUME_NONNULL_END
