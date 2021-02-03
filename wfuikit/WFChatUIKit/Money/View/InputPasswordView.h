//
//  InputPasswordView.h
//  WFChatUIKit
//
//  Created by xxx on 2019/11/25.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBLocalized.h"

NS_ASSUME_NONNULL_BEGIN

@protocol InputPasswordDelegate <NSObject>
@required
- (void)inputDone:(NSString *)password;
@optional
- (void)inputCancel;

@end

typedef void(^Complection)(NSString *result);

@interface InputPasswordView : UIView

@property (weak, nonatomic) IBOutlet UIView* backgroundView;
@property (weak, nonatomic) IBOutlet UIView* pwdBackgroundView;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *circle1;
@property (weak, nonatomic) IBOutlet UILabel *cirele2;
@property (weak, nonatomic) IBOutlet UILabel *circle3;
@property (weak, nonatomic) IBOutlet UILabel *cirele4;
@property (weak, nonatomic) IBOutlet UILabel *circle5;
@property (weak, nonatomic) IBOutlet UILabel *cirele6;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
+ (InputPasswordView *)showPassword:(NSString *)type money:(NSString *)money withDelegate:(UIViewController *)delegate;
@property (nonatomic, weak) id<InputPasswordDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
