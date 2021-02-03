//
//  HasInRobedResultList.m
//  WFChatUIKit
//
//  Created by xxx on 2019/11/23.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "HasInRobedResultList.h"
#import "SDWebImage.h"

@interface HasInRobedResultList ()


@end

@implementation HasInRobedResultList

+ (instancetype)createViewFromNibName:(NSString *)nibName
{
    NSBundle *bundle = [NSBundle bundleForClass:self];
    NSArray *nib = [bundle loadNibNamed:nibName owner:self options:nil];
    return [nib objectAtIndex:0];
}

+ (instancetype)createViewFromNib
{
    return [self createViewFromNibName:@"LuckyMoneyDrtailHeader"];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.moneyLabel.font = WechatFont(60);
    self.headerIcon.layer.masksToBounds = YES;
    self.headerIcon.layer.cornerRadius = 3.0;
}

- (void)setMineHidden {
    self.moneyLabel.hidden = YES;
    self.noteLabel.hidden = YES;
    self.hintLabel.hidden = YES;
    self.yuanLabel.hidden = YES;
}

- (void)setModel:(LuckyMoneyListModel *)model {
    WFCCUserInfo *user = [[WFCCIMService sharedWFCIMService] getUserInfo:model.userId refresh:NO];
    NSString *nameStr;
    if (user.friendAlias.length) {
        nameStr = user.friendAlias;
    } else {
        nameStr = user.displayName;
    }
    [self.headerIcon sd_setImageWithURL:[NSURL URLWithString:user.portrait] placeholderImage:[UIImage imageNamed:@"PersonalChat"]];
    self.nameDescLabel.text = [NSString stringWithFormat:@"%@的红包",nameStr];
    if (model.type == 0) {
        self.pinIcon.hidden = NO;
    } else {
        self.pinIcon.hidden = YES;
    }
    self.noteLabel.text = model.name;
    MoneyRecordModel *record = model.mineRecord;
    /// 我有没有抢到
    if (record) {
        /// 抢到了
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",record.money.intValue/100.0];
        NSString *result;
        if ([model.number integerValue] != model.records.count) {
            result = [NSString stringWithFormat:@"已领取%ld/%@，共%.2f/%.2f元",model.records.count, model.number,model.robedMoney/100.0,(model.money.doubleValue/100.0)];
        } else {
            /// 没有抢到
            result = [NSString stringWithFormat:@"%@个红包共%.2f元，已经被抢光",model.number,(model.money.doubleValue/100.0)];
        }
        self.resultLabel.text = result;
    } else {
        NSString *result;
        NSString *moneyStr = [NSString stringWithFormat:@"%.2f",model.money.doubleValue/100.0];
        /// 没有我
        if (self.isAgroup) {
            /// 群组
            result = [NSString stringWithFormat:@"已领取%ld/%@",model.records.count,model.number];
        } else {
            /// 1V1
            if (model.records.count == 1) {
                /// 已经被领取
                result = [NSString stringWithFormat:@"红包已被领取，已领取1/1个，共%@/%@元",moneyStr,moneyStr];
            } else {
                /// 还没有被领取
                if ([model.status integerValue] == 2) {
                    result = [NSString stringWithFormat:@"红包已过期，已领取0/1个，共0.00/%@元",moneyStr];
                } else {
                   result = [NSString stringWithFormat:@"红包待领取，已领取0/1个，共0.00/%@元",moneyStr];
                }
            }
        }
        self.noRobLabel.text = result;
        self.noRobView.hidden = NO;
    }
}

- (void)notInList {
    [self.yuanLabel setHidden:YES];
    [self.moneyLabel setHidden:YES];
    [self.hintLabel setHidden:YES];
}

@end
