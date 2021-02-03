//
//  WFCInfoTableViewCell.m
//  WildFireChat
//
//  Created by ccc on 2018/11/19.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "WFCInfoTableViewCell.h"

@implementation WFCInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.iconView.layer.masksToBounds = YES;
//    self.iconView.layer.cornerRadius = 4.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
