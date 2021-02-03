//
//  WFCLoginViewController.m
//  Wildfire Chat
//
//  Created by WF Chat on 2017/7/9.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#import "WFCLoginViewController.h"
#import <WFChatClient/WFCChatClient.h>
#import <WFChatUIKit/WFChatUIKit.h>
#import "AppDelegate.h"
#import "WFCBaseTabBarController.h"
#import "MBProgressHUD.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "WFCPrivacyViewController.h"
#import "SecertViewController.h"
#import "AppService.h"
#import "Tools.h"
#import "WFRegisterViewController.h"
//是否iPhoneX YES:iPhoneX屏幕 NO:传统屏幕
#define kIs_iPhoneX ([UIScreen mainScreen].bounds.size.height == 812.0f ||[UIScreen mainScreen].bounds.size.height == 896.0f )

#define kStatusBarAndNavigationBarHeight (kIs_iPhoneX ? 88.f : 64.f)

#define  kTabbarSafeBottomMargin        (kIs_iPhoneX ? 34.f : 0.f)

#define HEXCOLOR(rgbValue)                                                                                             \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0                                               \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0                                                  \
blue:((float)(rgbValue & 0xFF)) / 255.0                                                           \
alpha:1.0]

@interface WFCLoginViewController () <UITextFieldDelegate> {
    NSArray <UIButton *>* _btns;
    NSString *_registerUserId;
}
@property (strong, nonatomic) UILabel *hintLabel;
@property (strong, nonatomic) UITextField *userNameField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UIButton *loginBtn;

@property (strong, nonatomic) UIButton *languageBtn;

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
@property (nonatomic , strong) UIView *securtyLable;

@property (nonatomic, assign) CGFloat tY;
@property (nonatomic, assign) CGFloat tH;

@end

@implementation WFCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.2];
    bg.image = [UIImage imageNamed:@"beiying"];
    [self.view addSubview:bg];
    self.view.backgroundColor = [WFCUConfigManager globalManager].backgroudColor;
    self.unEnableColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:199/255.0 alpha:1.0];
    NSString *savedName = [[NSUserDefaults standardUserDefaults] stringForKey:@"savedName"];
   
    CGRect bgRect = self.view.bounds;
    CGFloat paddingEdge = 60;
    
    CGFloat paddingTF2Line = 8;
    CGFloat paddingLine2TF = 15;
    CGFloat sendCodeBtnwidth = 120;
    CGFloat sendingCodeBtnWidth = 60;
    CGFloat paddingField2Code = 8;
    CGFloat imageWidth = 200;
    
    CGFloat topPos = kStatusBarAndNavigationBarHeight + 10;
    CGFloat fieldHeight = 45;
    CGFloat edageTop = 25;
    
    UIImageView *iconImage = [UIImageView new];
    iconImage.backgroundColor = UIColor.clearColor;
    iconImage.image = [UIImage imageNamed:@"labi_login_icon"];
    iconImage.layer.masksToBounds = YES;
    iconImage.layer.cornerRadius = 10.0;
    iconImage.frame = CGRectMake((bgRect.size.width - imageWidth)/2, topPos , imageWidth, imageWidth);
    [self.view addSubview: iconImage];
    
    UIFont *textFont = [UIFont systemFontOfSize:17];
    self.hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingEdge, topPos - 40, bgRect.size.width - paddingEdge - paddingEdge, fieldHeight*2)];
    [self.hintLabel setText:LocalizedString(@"Login")];
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    self.hintLabel.font = [UIFont systemFontOfSize:fieldHeight];
    
    topPos = CGRectGetMaxY(iconImage.frame) + 10;
    
    self.userNameField = [[UITextField alloc] initWithFrame:CGRectMake(paddingEdge , topPos, bgRect.size.width - paddingEdge * 2, fieldHeight)];
    
    UIImageView *usericon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phoneicon"]];
    usericon.frame = CGRectMake(0, 8, 16, 24);
    UIView *l = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    [l addSubview:usericon];
//    self.userNameField.leftView = l;
    self.userNameField.leftViewMode = UITextFieldViewModeAlways;
    self.userNameField.placeholder = [NSString stringWithFormat:@"%@", LocalizedString(@"AccountPlaceholder")];
    self.userNameField.returnKeyType = UIReturnKeyNext;
    self.userNameField.keyboardType = UIKeyboardTypeURL;
    self.userNameField.delegate = self;
    self.userNameField.font = textFont;
    self.userNameField.textColor = UIColor.whiteColor;
    self.userNameField.layer.borderColor = Tools.getThemeColor.CGColor;
    self.userNameField.layer.borderWidth = 1.f;
    self.userNameField.layer.masksToBounds = YES;
    self.userNameField.layer.cornerRadius = fieldHeight/2;
    self.userNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.userNameField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.userNameField.textAlignment = NSTextAlignmentLeft;
    self.userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.userNameField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    topPos = CGRectGetMaxY(self.userNameField.frame) + edageTop;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = Tools.getThemeColor;
    [self.view addSubview:line];
    line.hidden = YES;
    line.frame = CGRectMake(paddingEdge, topPos - edageTop + 5, bgRect.size.width - paddingEdge * 2, 1/UIScreen.mainScreen.scale);
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(paddingEdge, topPos, bgRect.size.width - paddingEdge * 2, fieldHeight)];
    
    usericon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"passworticon"]];
    usericon.frame = CGRectMake(0, 8, 16, 24);
    l = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    [l addSubview:usericon];
//    self.passwordField.leftView = l;
    self.passwordField.placeholder = [NSString stringWithFormat:@"%@", LocalizedString(@"PasswordPlaceholder")];
    self.passwordField.returnKeyType = UIReturnKeyDone;
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.keyboardType = UIKeyboardTypeDefault;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.delegate = self;
    self.passwordField.layer.borderColor = Tools.getThemeColor.CGColor;
    self.passwordField.layer.borderWidth = 1.f;
    self.passwordField.layer.masksToBounds = YES;
    self.passwordField.layer.cornerRadius = fieldHeight/2;
//    self.passwordField.borderStyle = UITextBorderStyleBezel;
    self.passwordField.tintColor = WFCCUtilities.wechatGreenColor;
    self.passwordField.font = textFont;
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.textAlignment = NSTextAlignmentCenter;
    self.passwordField.textColor = UIColor.whiteColor;
    self.userNameField.font = [UIFont systemFontOfSize:16];
    self.passwordField.font = [UIFont systemFontOfSize:16];
    self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.passwordField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.passwordField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];

    self.passwordField.textAlignment = NSTextAlignmentCenter;
    self.userNameField.textAlignment = NSTextAlignmentCenter;
    topPos = CGRectGetMaxY(self.passwordField.frame) + edageTop;
    
    line = [[UIView alloc] init];
    line.backgroundColor = Tools.getThemeColor;
    [self.view addSubview:line];
    line.frame = CGRectMake(paddingEdge, topPos - edageTop + 5, bgRect.size.width - paddingEdge * 2, 1/UIScreen.mainScreen.scale);
    CGFloat registrtTop = topPos + 10;
    line.hidden = YES;
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(paddingEdge, topPos, bgRect.size.width - paddingEdge - paddingEdge, fieldHeight)];
//    [self.loginBtn setBackgroundColor: Tools.getThemeColor];
    
    [self.loginBtn addTarget:self action:@selector(onLoginButton:) forControlEvents:UIControlEventTouchDown];
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = fieldHeight/2;
    [self.loginBtn setTitle:LocalizedString(@"Login") forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"labi_btn_bg_hl"] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.loginBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    
    topPos = CGRectGetMaxY(self.loginBtn.frame) + edageTop;
    self.languageBtn = [[UIButton alloc] initWithFrame:CGRectMake(paddingEdge, topPos, bgRect.size.width - paddingEdge - paddingEdge, fieldHeight)];
    [self.languageBtn setBackgroundColor: UIColor.greenColor];
    
    [self.languageBtn addTarget:self action:@selector(changeLanage) forControlEvents:UIControlEventTouchDown];
    self.languageBtn.layer.masksToBounds = YES;
    self.languageBtn.layer.cornerRadius = fieldHeight/2;
    [self.languageBtn setTitle:LocalizedString(@"ChangeLaunage") forState:UIControlStateNormal];
    self.languageBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    
    [self.view addSubview:self.userNameField];
    [self.view addSubview:self.passwordField];
    
    [self.view addSubview:self.loginBtn];
    self.userNameField.text = savedName;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetKeyboard:)]];
    
    self.changeloginBtn = [[UIButton alloc] initWithFrame:CGRectMake(paddingEdge, registrtTop-12, 100, 35)];
//    self.changeloginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.changeloginBtn setTitle:LocalizedString(@"Register") forState:UIControlStateNormal];
    [self.changeloginBtn setTitleColor:[UIColor colorWithRed:67/255.0 green:88/255.0 blue:131/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.changeloginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.changeloginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.view addSubview:self.changeloginBtn];
    [self.changeloginBtn addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
//    self.changeloginBtn.hidden = YES;
    [self addBtn];
    
    self.changeloginBtn.frame = CGRectMake(paddingEdge, topPos + 10, bgRect.size.width - paddingEdge - paddingEdge, fieldHeight);
    [self.changeloginBtn setBackgroundImage:[UIImage imageNamed:@"labi_btn_bg_hl"] forState:UIControlStateNormal];
    self.changeloginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.changeloginBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
}

- (void)registerUser {
    WFRegisterViewController *registerVC = [WFRegisterViewController new];
    registerVC.modalPresentationStyle = UIModalPresentationFullScreen;
    __weak typeof(self) weakSelf = self;
    registerVC.block = ^(NSString *token) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf->_registerUserId = token;
        [strongSelf inputInviateCode];
    };
    [self presentViewController:registerVC animated:true completion:nil];
}

- (void)inputInviateCode{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalizedString(@"RegisterCodePlaceHolder") message:nil preferredStyle:UIAlertControllerStyleAlert];
    //以下方法就可以实现在提示框中输入文本；
    //在AlertView中添加一个输入框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = LocalizedString(@"RegisterCodePlaceHolder");
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
        NSString *str = envirnmentNameTextField.text;
        if (str.length > 0) {
            [self sureInverter:str];
        }
        
    }]];
    //添加一个取消按钮
   
    //present出AlertView
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)sureInverter:(NSString *)code {
    NSDictionary *param = @{@"id":_registerUserId, @"regCode": code};
    [[NetworkAPI sharedInstance] v2GetWithUrl:APP_REGISTER_V2  params:param successComplection:^(NSDictionary * _Nonnull done) {
        NSString *status = [NSString stringWithFormat:@"%@", done[@"status"]];
        if ([status isEqualToString:@"0"]) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSendCode:(id)sender {
    self.sendCodeBtn.enabled = NO;
    [self.sendCodeBtn setTitle:@"短信发送中" forState:UIControlStateNormal];
    __weak typeof(self)ws = self;
    NSDictionary *param = @{@"mobile":self.userNameField.text};
    [[AppService sharedAppService] sendCode:self.userNameField.text success:^{
        [ws sendCodeDone:YES];
    } error:^(NSString * _Nonnull message) {
        [ws sendCodeDone:NO];
    }];
}

- (void) setLoginEnable:(BOOL) enable {
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
}

- (void)changeLanage {
    
    UIAlertController *alertController = [[UIAlertController alloc] init];
    //初始化一个UIAlertController的警告框将要用到的UIAlertAction style cancle
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:LocalizedString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    //初始化一个UIAlertController的警告框将要用到的UIAlertAction style Default
    UIAlertAction *wx = [UIAlertAction actionWithTitle:@"English" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self reseLanguageFromype:kLanguageTypeEn];
    }];
    //初始化一个UIAlertController的警告框将要用到的UIAlertAction style Default
    UIAlertAction *wb = [UIAlertAction actionWithTitle:@"中文" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self reseLanguageFromype:kLanguageTypeZhHans];
    }];
    
    //初始化一个UIAlertController的警告框将要用到的UIAlertAction style Default
    UIAlertAction *yuenan = [UIAlertAction actionWithTitle:@"Malaysia" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self reseLanguageFromype:kLanguageVi];
    }];
    //将初始化好的UIAlertAction添加到UIAlertController中
    [alertController addAction:cancle];
    [alertController addAction:wx];
    [alertController addAction:wb];
    [alertController addAction:yuenan];
    //将初始化好的j提示框显示出来
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)reseLanguageFromype:(LanguageType)type {
    if ([[ZBLocalized sharedInstance] setLanguage: type]) {
        [self reSetLanguage];
    }
}

- (void)onLoginButton:(id)sender {
    NSString *user = self.userNameField.text;
    NSString *password = self.passwordField.text;
    NSString *clientId = [[WFCCNetworkService sharedInstance] getClientId];
    if (!user.length || !password.length) {
        return;
    }
    [self resetKeyboard:nil];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = LocalizedString(@"Login");
    [hud showAnimated:YES];
    NSDictionary *params = @{@"username":user,@"password":password,@"clientId":clientId};
    [[NetworkAPI sharedInstance] postWithUrl:LOGIN_BY_PASSWORD params:params successComplection:^(NSDictionary * _Nonnull done) {
        NSString *token = done[@"data"][@"imToken"];
        NSString *userId = done[@"data"][@"userId"];
        [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"savedName"];
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"savedToken"];
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"savedUserId"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [[WFCCNetworkService sharedInstance] connect:userId token:token];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            WFCBaseTabBarController *tabBarVC = [WFCBaseTabBarController new];
            tabBarVC.newUser = NO;
            [UIApplication sharedApplication].delegate.window.rootViewController =  tabBarVC;
        });
    } failureComplection:^(NSDictionary * _Nonnull done) {
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.label.text = [NSString stringWithFormat:@"登录失败%@",done[@"msg"]];
            [hud hideAnimated:YES afterDelay:0.5];
        });
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userNameField) {
        [self.passwordField becomeFirstResponder];
    } else if(textField == self.passwordField) {
        [self onLoginButton:nil];
    }
    return NO;
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
//    NSString * MOBILE = @"^((1[34578]))\\d{9}$";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    if (self.userNameField.text.length == 11 && ([regextestmobile evaluateWithObject:self.userNameField.text] == YES)) {
//        return YES;
//    } else {
//        return NO;
//    }
}

- (BOOL)isValidCode {
    return self.passwordField.text.length >= 1;
//    if (self.passwordField.text.length >= 4) {
//        return YES;
//    } else {
//        return NO;
//    }
}

- (BOOL)isValidSecurity {
    if (self.securtyField.text.length >= 4) {
        return YES;
    } else {
        return NO;
    }
}

- (void)reSetLanguage {
    [self.loginBtn setTitle:LocalizedString(@"Login") forState:UIControlStateNormal];
    [self.hintLabel setText:LocalizedString(@"Login")];
    self.userNameField.placeholder = LocalizedString(@"AccountPlaceholder");
    self.passwordField.placeholder = LocalizedString(@"PasswordPlaceholder");
    [self.changeloginBtn setTitle:LocalizedString(@"Register") forState:UIControlStateNormal];
}


- (void)addBtn {
    CGFloat h = UIScreen.mainScreen.bounds.size.height;
    CGFloat w = UIScreen.mainScreen.bounds.size.width;
    CGFloat top = h - 100;
    CGFloat lf = (w - 80)/2;
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:3];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(lf ,top , 80, 40);
    [btn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btn setTitle:@"English" forState:UIControlStateNormal];
    btn.tag = 1000 + 1;
    [btn addTarget:self action:@selector(setLanguageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [a addObject:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(lf - 80 ,top , 80, 40);
    [btn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btn setTitle:@"中文" forState:UIControlStateNormal];
    btn.tag = 1000 + 2;
    [btn addTarget:self action:@selector(setLanguageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [a addObject:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(lf + 80 ,top , 80, 40);
    [btn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btn setTitle:@"Malaysia" forState:UIControlStateNormal];
    btn.tag = 1000 + 3;
    [btn addTarget:self action:@selector(setLanguageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [a addObject:btn];
    _btns = [NSArray arrayWithArray:a];
    
    btn = [self.view viewWithTag:[[ZBLocalized sharedInstance] currentLanguareType] + 1000];
    btn.selected = YES;
}

- (void)setLanguageClick:(UIButton *)sender {
    for (UIButton *btn in _btns) {
        [btn setSelected:NO];
    }
    sender.selected = YES;
    [self reseLanguageFromype:sender.tag - 1000];
}

@end
