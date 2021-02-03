//
//  ListMoneyCell.m
//  WildFireChat
//
//  Created by xxx on 2018/12/15.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "ListMoneyCell.h"

@implementation ListMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColor.whiteColor;
}

- (void)setRecord:(XXMoneyRecordModel *)record {
    self.moneyLabel.text = record.amountStr;
    self.timeLabel.text = record.created_time;
    self.typeLabel.text = record.typeString;
    if ([record lessZero]) {
        self.moneyLabel.textColor = [UIColor blackColor];
    } else {
        self.moneyLabel.textColor = Tools.getThemeColor;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
