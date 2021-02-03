//
//  HasInRobedResultList.h
//  WFChatUIKit
//
//  Created by xxx on 2019/11/23.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LuckyMoneyListModel.h"
#import "ZBLocalized.h"

NS_ASSUME_NONNULL_BEGIN

@interface HasInRobedResultList : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameDescLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pinIcon;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgRed;
@property (weak, nonatomic) IBOutlet UILabel *yuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UIView *noRobView;
@property (weak, nonatomic) IBOutlet UILabel *noRobLabel;


@property (nonatomic, assign) BOOL isAgroup;
- (void)setModel:(LuckyMoneyListModel *)model;

+ (instancetype)createViewFromNib;
- (void)notInList;
- (void)setMineHidden;
@end

NS_ASSUME_NONNULL_END
