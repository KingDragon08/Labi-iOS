//
//  PresentNavigationBar.h
//  WFChatUIKit
//
//  Created by xxx on 2019/11/20.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBLocalized.h"

NS_ASSUME_NONNULL_BEGIN

@interface PresentNavigationBar : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIView *lineView;

- (void)setLeftTitle;
- (void)showBackImage;

@end

NS_ASSUME_NONNULL_END
