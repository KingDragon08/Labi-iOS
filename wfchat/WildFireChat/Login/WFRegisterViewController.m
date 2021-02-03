//
//  WFRegisterViewController.m
//  WildFireChat
//
//  Created by xxxty on 2018/2/25.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "WFRegisterViewController.h"
#import <WFChatUIKit/WFChatUIKit.h>
#import <WFChatClient/WFCChatClient.h>
#import "AppDelegate.h"
#import "WFCBaseTabBarController.h"
#import "MBProgressHUD.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "WFCPrivacyViewController.h"
#import "AppService.h"
#import "Tools.h"
#import "WFRegisterManager.h"
#import "SecertViewController.h"
#import "WFUserModel.h"

//是否iPhoneX YES:iPhoneX屏幕 NO:传统屏幕
#define kIs_iPhoneX ([UIScreen mainScreen].bounds.size.height == 812.0f ||[UIScreen mainScreen].bounds.size.height == 896.0f )

#define kStatusBarAndNavigationBarHeight (kIs_iPhoneX ? 88.f : 64.f)

#define  kTabbarSafeBottomMargin        (kIs_iPhoneX ? 34.f : 0.f)

#define HEXCOLOR(rgbValue)                                                                                             \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0                                               \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0                                                  \
blue:((float)(rgbValue & 0xFF)) / 255.0                                                           \
alpha:1.0]

@interface WFRegisterViewController ()<UITextFieldDelegate> {
    NSString *_registerUserId;
}

@property (nonatomic, strong) PresentNavigationBar *bar;
@property (strong, nonatomic) UILabel *hintLabel;
@property (strong, nonatomic) UITextField *userNameField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UITextField *registerField;
@property (strong, nonatomic) UIButton *loginBtn;

@property (strong, nonatomic) UIView *userNameLine;
@property (strong, nonatomic) UIView *passwordLine;

@property (strong, nonatomic) UIButton *sendCodeBtn;
@property (nonatomic, strong) NSTimer *countdownTimer;
@property (nonatomic, assign) NSTimeInterval sendCodeTime;
@property (nonatomic, strong) UILabel *privacyLabel;

@property (nonatomic, assign) CGFloat sendWidth;
@property (nonatomic, assign) CGFloat sendTop;
@property (nonatomic, assign) CGFloat sendX;
@property (nonatomic, strong) UIColor *unEnableColor;


/// 改变登录状态 验证码-密码登录
@property (nonatomic, strong) UIButton *changeloginBtn;
/// 验证码登录方式
@property (nonatomic, assign) BOOL verfyLoginType;

@property (nonatomic , strong) UIView *securtyView;
@property (nonatomic , strong) UIView *verfyView;
@property (nonatomic , strong) UITextField *securtyField;
@property (nonatomic , strong) UITextField *sureSecurtyField;
@property (nonatomic , strong) UIView *securtyLable;

@property (nonatomic, assign) CGFloat tY;
@property (nonatomic, assign) CGFloat tH;

@property (nonatomic , strong) WFRegisterManager *manager;

@end

@implementation WFRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    self.manager = [WFRegisterManager new];
}

- (void)initUI {
    PresentNavigationBar *bar = [[PresentNavigationBar alloc] init];
    bar.backgroundColor = [WFCUConfigManager globalManager].backgroudColor;
    bar.titleLabel.textColor = Tools.getThemeColor;
    [bar.backBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [bar.backBtn addTarget:self action:@selector(backCLick) forControlEvents:UIControlEventTouchUpInside];
    [bar.lineView setHidden:YES];
    [bar setLeftTitle];
    bar.titleLabel.text = LocalizedString(@"Register");
    [self.view addSubview:bar];
    self.view.backgroundColor = [WFCUConfigManager globalManager].backgroudColor;
//
    self.unEnableColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:199/255.0 alpha:1.0];
    NSString *savedName = [[NSUserDefaults standardUserDefaults] stringForKey:@"savedName"];
    
    CGRect bgRect = self.view.bounds;
    CGFloat paddingEdge = 20;
    
    CGFloat paddingTF2Line = 8;
    CGFloat paddingLine2TF = 15;
    CGFloat sendCodeBtnwidth = 120;
    CGFloat sendingCodeBtnWidth = 60;
    CGFloat paddingField2Code = 8;
    
    CGFloat topPos = kStatusBarAndNavigationBarHeight;
    CGFloat fieldHeight = 25;
    
    UIFont *textFont = [UIFont systemFontOfSize:16];
    self.hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingEdge, topPos - 40, bgRect.size.width - paddingEdge - paddingEdge, 0)];
    //        [self.hintLabel setText:@"登录"];
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    self.hintLabel.font = [UIFont systemFontOfSize:fieldHeight];
    
    topPos += fieldHeight * 2 + 10;
    
    self.userNameLine = [[UIView alloc] initWithFrame:CGRectMake(paddingEdge, topPos + paddingTF2Line + fieldHeight, bgRect.size.width - paddingEdge - paddingEdge, WFCCUtilities.onepxLine)];
    self.userNameLine.backgroundColor = WFCCUtilities.onePxLineColor;
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingEdge, topPos, 120, fieldHeight)];
    phoneLabel.text = LocalizedString(@"Account");
    phoneLabel.font = textFont;
    phoneLabel.textColor = Tools.getThemeColor;
    [self.view addSubview:phoneLabel];
    
    self.userNameField = [[UITextField alloc] initWithFrame:CGRectMake(paddingEdge+phoneLabel.frame.size.width, topPos, bgRect.size.width - paddingEdge - paddingEdge - phoneLabel.frame.size.width, fieldHeight)];
    self.userNameField.placeholder = LocalizedString(@"AccountPlaceholder");
    self.userNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.userNameField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.userNameField.tintColor = WFCCUtilities.wechatGreenColor;
    self.userNameField.returnKeyType = UIReturnKeyNext;
    self.userNameField.keyboardType = UIKeyboardTypeURL;
    self.userNameField.delegate = self;
    self.userNameField.font = textFont;
    self.userNameField.textColor = UIColor.whiteColor;
    self.userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.userNameField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.tH = topPos + paddingTF2Line + fieldHeight + paddingLine2TF + fieldHeight + paddingTF2Line - (topPos + paddingTF2Line + fieldHeight + paddingLine2TF);
    self.tY = topPos + paddingTF2Line + fieldHeight + paddingLine2TF;
    self.verfyView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tY, self.view.frame.size.width, self.tH)];
    
    
    self.passwordLine = [[UIView alloc] initWithFrame:CGRectMake(paddingEdge, self.tH - WFCCUtilities.onepxLine, bgRect.size.width - paddingEdge - paddingEdge, WFCCUtilities.onepxLine)];
    
    self.passwordLine.backgroundColor = WFCCUtilities.onePxLineColor;
    
    UILabel *verfyLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingEdge, 0,phoneLabel.frame.size.width , fieldHeight)];
    verfyLabel.text = LocalizedString(@"Password");
    verfyLabel.font = textFont;
    verfyLabel.textColor = Tools.getThemeColor;
    [self.view addSubview:verfyLabel];
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(paddingEdge + phoneLabel.frame.size.width, 0, bgRect.size.width - paddingEdge - paddingEdge - phoneLabel.frame.size.width, fieldHeight)];
    self.passwordField.placeholder = LocalizedString(@"PasswordPlaceholder");
    self.passwordField.returnKeyType = UIReturnKeyDone;
    self.passwordField.keyboardType = UIKeyboardTypeDefault;
    
    self.passwordField.delegate = self;
    self.passwordField.tintColor = WFCCUtilities.wechatGreenColor;
    self.passwordField.font = textFont;
    self.passwordField.textColor = UIColor.whiteColor;
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.passwordField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.verfyView addSubview:verfyLabel];
    [self.verfyView addSubview:self.passwordField];
    [self.verfyView addSubview:_passwordLine];
    self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.passwordField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    UILabel *sureVerfyLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingEdge, CGRectGetMaxY(self.verfyView.frame) + 15,phoneLabel.frame.size.width , fieldHeight)];
    sureVerfyLabel.text = LocalizedString(@"RegisterCode");
    sureVerfyLabel.font = textFont;
    sureVerfyLabel.textColor = Tools.getThemeColor;
    [self.view addSubview:sureVerfyLabel];
    
    self.sureSecurtyField = [[UITextField alloc] initWithFrame:CGRectMake(paddingEdge + phoneLabel.frame.size.width, sureVerfyLabel.frame.origin.y, bgRect.size.width - paddingEdge - paddingEdge - phoneLabel.frame.size.width, fieldHeight)];
    self.sureSecurtyField.placeholder = LocalizedString(@"RegisterCodePlaceHolder");
    self.sureSecurtyField.returnKeyType = UIReturnKeyDone;
    self.sureSecurtyField.keyboardType = UIKeyboardTypeDefault;
    
    self.sureSecurtyField.delegate = self;
    self.sureSecurtyField.tintColor = WFCCUtilities.wechatGreenColor;
    self.sureSecurtyField.font = textFont;
    self.sureSecurtyField.textColor = UIColor.whiteColor;
    self.sureSecurtyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.sureSecurtyField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.sureSecurtyField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.sureSecurtyField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.view addSubview:self.sureSecurtyField];
    
    UIView *sureLine = [[UIView alloc] initWithFrame:CGRectMake(paddingEdge, CGRectGetMaxY(self.sureSecurtyField.frame) + 12, bgRect.size.width - paddingEdge - paddingEdge, WFCCUtilities.onepxLine)];
    sureLine.backgroundColor = WFCCUtilities.onePxLineColor;
    [self.view addSubview:sureLine];
    
    
    sureVerfyLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingEdge, CGRectGetMaxY(sureLine.frame) + 15,phoneLabel.frame.size.width , fieldHeight)];
    sureVerfyLabel.text = LocalizedString(@"RegisterCode");
    sureVerfyLabel.font = textFont;
    sureVerfyLabel.textColor = Tools.getThemeColor;
//    [self.view addSubview:sureVerfyLabel];
    
    self.registerField = [[UITextField alloc] initWithFrame:CGRectMake(paddingEdge + phoneLabel.frame.size.width, sureVerfyLabel.frame.origin.y, bgRect.size.width - paddingEdge - paddingEdge - phoneLabel.frame.size.width, fieldHeight)];
    self.registerField.placeholder = LocalizedString(@"RegisterCodePlaceHolder");
    self.registerField.returnKeyType = UIReturnKeyDone;
    self.registerField.keyboardType = UIKeyboardTypeDefault;
    self.registerField.secureTextEntry = YES;
    self.registerField.delegate = self;
    self.registerField.tintColor = WFCCUtilities.wechatGreenColor;
    self.registerField.font = textFont;
    self.registerField.textColor = UIColor.whiteColor;
    self.registerField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.registerField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.registerField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [self.view addSubview:self.registerField];
    
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(paddingEdge, 30+topPos + paddingTF2Line + fieldHeight + paddingLine2TF + fieldHeight + paddingTF2Line + paddingLine2TF + 90, bgRect.size.width - paddingEdge - paddingEdge, 45)];
    [self.loginBtn setBackgroundColor: Tools.getThemeColor];
    
    self.loginBtn.enabled = false;
    [self.loginBtn addTarget:self action:@selector(onLoginButton:) forControlEvents:UIControlEventTouchDown];
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 5.f;
    [self.loginBtn setTitle:LocalizedString(@"Register") forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.loginBtn.enabled = NO;
    
    [self.view addSubview:self.hintLabel];
    [self.view addSubview:self.userNameLine];
    [self.view addSubview:self.userNameField];
    [self.view addSubview:self.verfyView];
    
    
    [self.view addSubview:self.loginBtn];
    
    self.userNameField.text = savedName;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetKeyboard:)]];
    [self setLoginEnable:NO];
    [self setSendBtnLaye:NO];
    self.sendX =  self.sendCodeBtn.frame.origin.x;
    self.sendWidth = self.sendCodeBtn.frame.size.width;
    
    
    self.securtyView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, self.tY, self.view.frame.size.width, _tH)];
    
    
    UIView *securityLine = [[UIView alloc] initWithFrame:CGRectMake(paddingEdge, _tH - WFCCUtilities.onepxLine, bgRect.size.width - paddingEdge - paddingEdge, WFCCUtilities.onepxLine)];
    securityLine.backgroundColor = WFCCUtilities.onePxLineColor;
    
    UILabel *securityLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingEdge, 0,80 , fieldHeight)];
    securityLabel.text = LocalizedString(@"Password");
    securityLabel.textAlignment = NSTextAlignmentLeft;
    securityLabel.font = textFont;
    securityLabel.textColor = [UIColor blackColor];
    
    self.securtyField = [[UITextField alloc] initWithFrame:CGRectMake(paddingEdge + 80, 0, bgRect.size.width - 80 - paddingEdge*2 , fieldHeight)];
    
    self.securtyField.placeholder = LocalizedString(@"PasswordPlaceholder");
    self.securtyField.returnKeyType = UIReturnKeyDone;
    self.securtyField.secureTextEntry = YES;
    self.securtyField.delegate = self;
    self.securtyField.tintColor = Tools.getThemeColor;
    self.securtyField.font = textFont;
    self.securtyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.securtyField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.securtyView addSubview:securityLine];
    [self.securtyView addSubview:securityLabel];
    [self.securtyView addSubview:self.securtyField];
    [self.view addSubview:self.securtyView];
    
    self.changeloginBtn = [[UIButton alloc] initWithFrame:CGRectMake(paddingEdge, CGRectGetMaxY(self.verfyView.frame)+ 10, 100, 20)];
    self.changeloginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.changeloginBtn setTitle:LocalizedString(@"Register") forState:UIControlStateNormal];
    [self.changeloginBtn setHidden:YES];
    [self.changeloginBtn setTitleColor:[UIColor colorWithRed:67/255.0 green:88/255.0 blue:131/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.changeloginBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.changeloginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.changeloginBtn addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.changeloginBtn];
}

/// 注册账号
- (void)registerUser {
    
}

- (void) showSecert {
    SecertViewController *svc = [[SecertViewController alloc] init];
    svc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:svc animated:true completion:nil];
}

- (void)changeLoginWay {
    [self.changeloginBtn setSelected:!self.changeloginBtn.isSelected];
    if (self.changeloginBtn.isSelected) {
        [UIView animateWithDuration:0.25 animations:^{
            self.securtyView.frame = CGRectMake(0, self.tY, self.view.frame.size.width, self.tH);
            self.verfyView.frame = CGRectMake(-self.view.frame.size.width, self.tY, self.view.frame.size.width, self.tH);
        } completion:^(BOOL finished) {
            self.verfyView.frame = CGRectMake(self.view.frame.size.width, self.tY, self.view.frame.size.width, self.tH);
            self.passwordField.text = nil;
            [self updateBtn];
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.verfyView.frame = CGRectMake(0, self.tY, self.view.frame.size.width, self.tH);
            self.securtyView.frame = CGRectMake(-self.view.frame.size.width, self.tY, self.view.frame.size.width, self.tH);
        } completion:^(BOOL finished) {
            self.securtyView.frame = CGRectMake(self.view.frame.size.width, self.tY, self.view.frame.size.width, self.tH);
            self.securtyField.text = nil;
            [self updateBtn];
        }];
    }
}

- (void)backCLick {
    [self dismissViewControllerAnimated:true completion:nil];
}


- (void)onSendCode:(id)sender {
    self.sendCodeBtn.enabled = NO;
    [self.sendCodeBtn setTitle:@"短信发送中" forState:UIControlStateNormal];
    __weak typeof(self)ws = self;
    [[AppService sharedAppService] sendCode:self.userNameField.text success:^{
        [ws sendCodeDone:YES];
    } error:^(NSString * _Nonnull message) {
        [ws sendCodeDone:NO];
    }];
}

- (void)setLoginEnable:(BOOL) enable {
    //    enable = YES;
    if (enable) {
        self.loginBtn.alpha = 1;
    } else {
        self.loginBtn.alpha = 0.4;
    }
}

- (void)setSendBtnLaye:(BOOL)enable {
    if (enable) {
        self.sendCodeBtn.layer.borderColor = [[UIColor blackColor] CGColor];
        [self.sendCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        self.sendCodeBtn.layer.borderColor = [self.unEnableColor CGColor];
        [self.sendCodeBtn setTitleColor:self.unEnableColor forState:UIControlStateNormal];
    }
}

- (void)updateCountdown:(id)sender {
    int second = (int)([NSDate date].timeIntervalSince1970 - self.sendCodeTime);
    [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%d秒后重新发送", 60-second] forState:UIControlStateNormal];
    CGRect codeFrame = self.sendCodeBtn.frame;
    self.sendCodeBtn.enabled = NO;
    self.sendCodeBtn.frame = CGRectMake(_sendX - 20, codeFrame.origin.y, _sendWidth + 20, codeFrame.size.height);
    if (second >= 60) {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
        [self.sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        CGRect codeFrame = self.sendCodeBtn.frame;
        self.sendCodeBtn.frame = CGRectMake(_sendX, codeFrame.origin.y, _sendWidth, codeFrame.size.height);
        self.sendCodeBtn.enabled = YES;
    }
    [self setSendBtnLaye:self.sendCodeBtn.enabled];
}
- (void)sendCodeDone:(BOOL)success {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (success) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"发送成功";
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            self.sendCodeTime = [NSDate date].timeIntervalSince1970;
            self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                   target:self
                                                                 selector:@selector(updateCountdown:)
                                                                 userInfo:nil
                                                                  repeats:YES];
            [self.countdownTimer fire];
            
            
            [hud hideAnimated:YES afterDelay:1.f];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"发送失败";
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:1.f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.sendCodeBtn.enabled = YES;
            });
        }
    });
}

- (void)resetKeyboard:(id)sender {
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.sureSecurtyField resignFirstResponder];
}

- (void)onLoginButton:(id)sender {
    
    if ([self.manager accountCanuse:self.userNameField.text] == NO) {
        [MBProgressHUD showHUDText:LocalizedString(@"nameHint") addedTo:self.view];
        return;
    }
    
    if ([self.manager passportCanuse:self.passwordField.text] == NO) {
        [MBProgressHUD showHUDText:LocalizedString(@"passHint") addedTo:self.view];
        return;
    }
    
    if (self.sureSecurtyField.text.length <= 0) {
        [MBProgressHUD showHUDText:LocalizedString(@"RegisterCodePlaceHolder") addedTo:self.view];
        return;
    }
    
    [[NetworkAPI sharedInstance] v2GetWithUrl:APP_VERFYCODE params:@{@"code": self.sureSecurtyField.text} successComplection:^(NSDictionary * _Nonnull done) {
        if ([done[@"data"][@"exist"] boolValue]) {
            [self registerUserxxx];
        } else {
            [MBProgressHUD showHUDText:LocalizedString(@"ICodeError") addedTo:self.view];
        }
    } failureComplection:^(NSDictionary * _Nonnull done) {
        [MBProgressHUD showHUDText:done[@"msg"] addedTo:self.view];
    }];
    [self resetKeyboard:nil];
}

- (void)registerUserxxx {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @".....";
    [hud showAnimated:YES];
    
    [self.manager registerAUserBy:self.userNameField.text andPassword:self.passwordField.text success:^(NSDictionary * _Nonnull done) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSDictionary *dic  = done[@"data"];
                self->_registerUserId = dic[@"userId"];
                [self sureInverter:self.sureSecurtyField.text];
            });
        });
    } failureComplection:^(NSDictionary * _Nonnull done) {
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.label.text = [NSString stringWithFormat:@"注册失败%@",done[@"msg"]];
            [hud hideAnimated:YES afterDelay:0.5];
        });
    }];
}

- (void)sureInverter:(NSString *)code {
    NSDictionary *param = @{@"id":_registerUserId, @"regCode": code};
    [[NetworkAPI sharedInstance] v2GetWithUrl:APP_REGISTER_V2  params:param successComplection:^(NSDictionary * _Nonnull done) {
        NSString *status = [NSString stringWithFormat:@"%@", done[@"status"]];
        if ([status isEqualToString:@"0"]) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [ToastManager showText:LocalizedString(@"success") inView:self.view];
        } else {
            [ToastManager showText:done[@"msg"] inView:self.view];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ToastManager hiddenHud];
        });
    } failureComplection:^(NSDictionary * _Nonnull done) {
        [ToastManager showText:LocalizedString(@"failure") inView:self.view];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ToastManager hiddenHud];
        });
    }];
    
}

- (void)secondRegister:(WFUserModel *)userModel {
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userNameField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [self.sureSecurtyField becomeFirstResponder];
    } else if(textField == self.sureSecurtyField) {
        [self onLoginButton:nil];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
#pragma mark - UITextInputDelegate
- (void)textDidChange:(id<UITextInput>)textInput {
    if (textInput == self.userNameField) {
        [self updateBtn];
    } else if (textInput == self.passwordField) {
        [self updateBtn];
    } else if (textInput == self.securtyField) {
        [self updateBtn];
    }
}

- (void)updateBtn {
    if ([self isValidNumber]) {
        if (!self.countdownTimer) {
            self.sendCodeBtn.enabled = YES;
            [self.sendCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        } else {
            self.sendCodeBtn.enabled = NO;
            [self.sendCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        if (self.changeloginBtn.isSelected) {
            /// 选择账号密码登录
            if ([self isValidSecurity]) {
                self.loginBtn.enabled = YES;
            } else {
                self.loginBtn.enabled = NO;
            }
        } else {
            /// 选择账号验证吗登录
            if ([self isValidCode]) {
                self.loginBtn.enabled = YES;
            } else {
                self.loginBtn.enabled = NO;
            }
        }
    } else {
        self.sendCodeBtn.enabled = NO;
        [self.sendCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    [self setLoginEnable:self.loginBtn.enabled];
    [self setSendBtnLaye:self.sendCodeBtn.enabled];
}

- (BOOL)isValidNumber {
    return self.userNameField.text.length >= 1;
}

- (BOOL)isValidCode {
    return self.passwordField.text.length >= 1;
    
}

- (BOOL)isValidSecurity {
    if (self.securtyField.text.length >= 4) {
        return YES;
    } else {
        return NO;
    }
}

@end
