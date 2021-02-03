//
//  ContactListCell.m
//  WFChatUIKit
//
//  Created by shangguan on 2019/11/26.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "ContactListCell.h"

@implementation ContactListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)tapSelect {
    if ([_userInfo.extra isEqualToString:@"0"]) {
        _userInfo.extra = @"1";
        [self.stateImage setImage:[UIImage imageNamed:@"CellBlueSelected"]];
        if (self.select) {
            self.select(_userInfo.userId);
        }
    } else {
        _userInfo.extra = @"0";
        [self.stateImage setImage:[UIImage imageNamed:@"CardPack_Add_UnSelected"]];
        if (self.deSelect) {
            self.deSelect(_userInfo.userId);
        }
    }
}

- (void)setUserInfo:(WFCCUserInfo *)userInfo {
    _userInfo = userInfo;
    if ([userInfo.extra isEqualToString:@"0"]) {
        [self.stateImage setImage:[UIImage imageNamed:@"CardPack_Add_UnSelected"]];
    } else {
        [self.stateImage setImage:[UIImage imageNamed:@"CellBlueSelected"]];
    }
    self.nameLabel.text = userInfo.displayName;
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:userInfo.portrait] placeholderImage:[UIImage imageNamed:@"PersonalChat"]];
}

@end
