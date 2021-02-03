//
//  BetsTableViewCell.m
//  WildFireChat
//
//  Created by xxx on 2018/12/15.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "BetsTableViewCell.h"

@interface BetsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;

@property (weak, nonatomic) IBOutlet UILabel *l1;
@property (weak, nonatomic) IBOutlet UILabel *l2;
@property (weak, nonatomic) IBOutlet UILabel *l3;
@property (weak, nonatomic) IBOutlet UILabel *l4;
@property (weak, nonatomic) IBOutlet UILabel *l5;
@property (weak, nonatomic) IBOutlet UILabel *l6;
@property (weak, nonatomic) IBOutlet UILabel *l7;

@end

@implementation BetsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _l1.text = LocalizedString(@"gameId");
    _l2.text = LocalizedString(@"bet");
    _l3.text = LocalizedString(@"created_time");
    _l4.text = LocalizedString(@"bonus");
    _l5.text = LocalizedString(@"type");
    _l6.text = LocalizedString(@"username");
    _l7.text = LocalizedString(@"win");
}

- (void)setModel:(BetsModel *)model {
    _label1.text = [NSString stringWithFormat:@"%ld", model.gameId];
    _label2.text = [model betStr];;
    _label3.text = [NSString stringWithFormat:@"%@", model.created_time];
    _label4.text = [model bondsStr];
    _label5.text = [NSString stringWithFormat:@"%ld", model.type];
    _label6.text = [NSString stringWithFormat:@"%@", model.username];
    _label7.text = [model winStr];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
