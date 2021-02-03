//
//  CardTableViewCell.m
//  WildFireChat
//
//  Created by xxx on 2018/12/15.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "CardTableViewCell.h"

@interface CardTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *left1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left2;
@property (weak, nonatomic) IBOutlet UILabel *left3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftL2;

@property (weak, nonatomic) IBOutlet UILabel *l2;

@end

@implementation CardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _left1.text = LocalizedString(@"Card Num");
    _l2.text = LocalizedString(@"UserName");
    _left3.text = LocalizedString(@"BankName");
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
