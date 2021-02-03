//
//  ListMoneyCell.h
//  WildFireChat
//
//  Created by xxx on 2018/12/15.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXMoneyRecordModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ListMoneyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic, strong) XXMoneyRecordModel *record;
@end

NS_ASSUME_NONNULL_END
