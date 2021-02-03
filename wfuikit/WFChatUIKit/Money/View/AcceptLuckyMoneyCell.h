//
//  AcceptLuckyMoneyCell.h
//  WFChatUIKit
//
//  Created by xxx on 2019/11/20.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LuckyMoneyListModel.h"
#import "SDWebImage.h"
#import "ZBLocalized.h"

NS_ASSUME_NONNULL_BEGIN

@interface AcceptLuckyMoneyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *winderView;

@property (nonatomic, strong) MoneyRecordModel *record;

@end

NS_ASSUME_NONNULL_END
