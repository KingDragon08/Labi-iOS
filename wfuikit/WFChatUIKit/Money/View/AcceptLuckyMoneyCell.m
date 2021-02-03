//
//  AcceptLuckyMoneyCell.m
//  WFChatUIKit
//
//  Created by xxx on 2019/11/20.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "AcceptLuckyMoneyCell.h"

@interface AcceptLuckyMoneyCell ()

@end

@implementation AcceptLuckyMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColor.whiteColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.nameLabel.textColor = UIColor.blackColor;
    self.moneyLabel.textColor = UIColor.blackColor;
}

- (void)setRecord:(MoneyRecordModel *)record {
    [self.headerIcon sd_setImageWithURL:[NSURL URLWithString:record.portrait] placeholderImage:[UIImage imageNamed:@"PersonalChat"]];
    self.nameLabel.text = record.showName;
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",record.money.intValue/100.0];
    self.timeLabel.text = record.createdAt;
    self.winderView.hidden = !record.luckyKing;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
