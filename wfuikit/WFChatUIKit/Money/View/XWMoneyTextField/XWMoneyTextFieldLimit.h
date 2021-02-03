//
//  XWMoneyTextFieldLimit.h
//  XWMoneyTextField
//
//  Created by smile.zhang on 16/3/10.
//  Copyright © 2016年 smile.zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZBLocalized.h"

@protocol XWMoneyTextFieldLimitDelegate;

@interface XWMoneyTextFieldLimit : NSObject <UITextFieldDelegate>

@property (nonatomic, assign) id <XWMoneyTextFieldLimitDelegate> delegate;
@property (nonatomic, strong) NSString *max; // 默认99999.99

- (void)inputValueChange:(id)sender;

@end

@protocol XWMoneyTextFieldLimitDelegate <NSObject>

- (void)inputValueChange:(id)sender;

@end
