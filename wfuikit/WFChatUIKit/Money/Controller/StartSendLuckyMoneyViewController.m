//
//  StartSendLuckyMoneyViewController.m
//  WFChatClient
//
//  Created by xxx on 2019/11/20.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import "StartSendLuckyMoneyViewController.h"
#import "InputPasswordView.h"
#import "XWMoneyTextField.h"

@interface StartSendLuckyMoneyViewController ()<UITextFieldDelegate,InputPasswordDelegate,XWMoneyTextFieldLimitDelegate>

@property (nonatomic, strong) XWMoneyTextField *moneyField;
@property (nonatomic, strong) UITextField *noteField;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *warningLabel;

@end

@implementation StartSendLuckyMoneyViewController {
    UIColor *_warningColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bar = [[PresentNavigationBar alloc] init];
    [self.bar.backBtn addTarget:self action:@selector(backCLick) forControlEvents:UIControlEventTouchUpInside];
    [self.bar setLeftTitle];
    self.bar.titleLabel.text = @"发红包";
    [self.view addSubview:self.bar];
    self.view.backgroundColor = self.bar.backgroundColor;
    _warningColor = [UIColor colorWithRed:227/255.0 green:194/255.0 blue:137/255.0 alpha:1.0];
    [self initUI];
}

// MARK: 输入框变化时
- (void)inputValueChange:(id)sender {
    if ([sender isKindOfClass:[XWMoneyTextField class]]) {
        XWMoneyTextField *field = (XWMoneyTextField *)sender;
        if (field.text != nil && field.text.length > 0 && (![field.text isEqualToString:@"0"])&& (![field.text isEqualToString:@"0."])&& (![field.text isEqualToString:@"0.0"])) {
            if (field.text.doubleValue - 200.0 > 0) {
                self.sendBtn.enabled = NO;
                self.sendBtn.alpha = 0.4;
                 [self showWarning];
            } else {
                 [self hiddenWarning];
                self.sendBtn.enabled = YES;
                self.sendBtn.alpha = 1;
            }
        } else {
             [self showWarning];
            self.sendBtn.enabled = NO;
            self.sendBtn.alpha = 0.4;
        }
        self.moneyLabel.text = [[NSString alloc] initWithFormat:@"¥%.2f",[field.text doubleValue]];
    }
}

- (void)inputDone:(NSString *)password {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:4];
    if (!self.moneyField.text | (self.moneyField.text.length == 0) | [self.moneyField.text isEqualToString:@"0"]| [self.moneyField.text isEqualToString:@"0.0"]| [self.moneyField.text isEqualToString:@"0."]) {
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%.2f",[self.moneyField.text doubleValue]];
    NSString *fen = [NSString stringWithFormat:@"%.0f",[str doubleValue] *100];
    [param setValue:[[WFCCNetworkService sharedInstance] userId] forKey:@"userId"];
    [param setValue:password forKey:@"payNumber"];
    [param setValue:fen forKey:@"money"];
    [param setValue:@"1" forKey:@"number"];
    [param setValue:@"1" forKey:@"type"];
    [param setValue:@"0" forKey:@"targetType"];
    [param setValue:self.targetUser.userId forKey:@"targetId"];
    
    NSString *noteStr = @"";
    if (self.noteField.text != nil && self.noteField.text.length > 0 ) {
        noteStr = self.noteField.text;
    } else {
        noteStr = @"恭喜发财，大吉大利";
    }
    [param setValue:noteStr forKey:@"name"];
    
    [ToastManager showText:@"" inView:self.view];
    [[NetworkAPI sharedInstance] postWithUrl:MONEY_LUCKYMONEY_CREATE params:param successComplection:^(NSDictionary * _Nonnull done) {
        LuckyMoneyListModel *lModel = [LuckyMoneyListModel mj_objectWithKeyValues:done[@"data"]];
        MessageContentModel *mModel = [[MessageContentModel alloc] init];
        mModel.redPId = lModel.redPId;
        mModel.money = fen;
        mModel.note = noteStr;
        if (self.block){
            self.block(mModel.mj_JSONString);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } failureComplection:^(NSDictionary * _Nonnull done) {
        [ToastManager showToast:done[@"msg"] inView:self.view];
    }];
}

- (void)sureBtnCLick{
    if (!self.moneyField.text | (self.moneyField.text.length == 0) | [self.moneyField.text isEqualToString:@"0"]| [self.moneyField.text isEqualToString:@"0.0"]| [self.moneyField.text isEqualToString:@"0."]) {
        return;
    }
    NSString *typeStr = [NSString stringWithFormat:@"微信红包"];
    NSString *payMoney = [NSString stringWithFormat:@"%.2f",self.moneyField.text.doubleValue];
    InputPasswordView *input = [InputPasswordView showPassword:typeStr money:payMoney withDelegate:self];
    [input.pwdTextField becomeFirstResponder];
}

- (void)initUI{
    UIView *bg1 = [[UIView alloc] initWithFrame:CGRectMake(20, self.bar.frame.size.height + 20, gScreenWidth - 40, 52)];
    bg1.backgroundColor = [UIColor whiteColor];
    bg1.layer.cornerRadius = 4.0;
    UILabel *jine = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 34, 52)];
    jine.font = [UIFont systemFontOfSize:16];
    jine.text = @"金额";
    [bg1 addSubview:jine];
    
    UILabel *yuan = [[UILabel alloc] initWithFrame:CGRectMake(gScreenWidth - 40 - 30, 0, 20, 52)];
    yuan.font = [UIFont systemFontOfSize:16];
    yuan.text = @"元";
    [bg1 addSubview:yuan];
    
    self.moneyField = [[XWMoneyTextField alloc] init];
    self.moneyField.frame = CGRectMake(63, 0, gScreenWidth - 40 - 105, 52);
    self.moneyField.textAlignment = NSTextAlignmentRight;
    self.moneyField.placeholder = @"0.00";
    self.moneyField.limit.delegate = self;
    [bg1 addSubview:self.moneyField];
    
    [self.view addSubview:bg1];
    
    UIView *bg2 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(bg1.frame)+ 20, gScreenWidth - 40, 52)];
    self.noteField = [[UITextField alloc] init];
    self.noteField.frame = CGRectMake(10, 0, gScreenWidth - 80, 52);
    self.noteField.textAlignment = NSTextAlignmentLeft;
    self.noteField.placeholder = @"恭喜发财,大吉大利";
    bg2.backgroundColor = bg1.backgroundColor;
    bg2.layer.cornerRadius = bg1.layer.cornerRadius;
    [bg2 addSubview:self.noteField];
    [self.view addSubview:bg2];
    
    self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 , CGRectGetMaxY(bg2.frame) + 60, gScreenWidth - 60, 45)];
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    self.moneyLabel.font = WechatFont(50);
//    self.moneyLabel.font = [UIFont boldSystemFontOfSize:40];
    self.moneyLabel.text = @"¥0.00";
    [self.view addSubview:self.moneyLabel];
    
    self.sendBtn = [[UIButton alloc] initWithFrame:CGRectMake((gScreenWidth - 170)/2, CGRectGetMaxY(self.moneyLabel.frame) + 40,170 , 50)];
    self.sendBtn.layer.cornerRadius = 4.0;
    [self.sendBtn setBackgroundColor: [UIColor colorWithRed:233/255.0 green:74/255.0 blue:44/255.0 alpha:1.0]];
    
    self.sendBtn.enabled = false;
    [self.sendBtn addTarget:self action:@selector(sureBtnCLick) forControlEvents:UIControlEventTouchDown];
    self.sendBtn.layer.masksToBounds = YES;
    self.sendBtn.layer.cornerRadius = 5.f;
    [self.sendBtn setTitle:@"塞钱进红包" forState:UIControlStateNormal];
    self.sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.sendBtn.enabled = NO;
    self.sendBtn.alpha = 0.4;
    [self.view addSubview:self.sendBtn];
    
    UILabel *hint = [[UILabel alloc] init];
    hint.text = @"未领取的红包，将在24小时后发起退款";
    hint.textAlignment = NSTextAlignmentCenter;
    hint.textColor = [UIColor grayColor];
    hint.font = [UIFont systemFontOfSize:12];
    hint.frame = CGRectMake(40, gScreenHeight - gSafeAreaInsets.bottom - 40, gScreenWidth - 80, 20);
    [self.view addSubview:hint];
    
    [self.view insertSubview:self.warningLabel aboveSubview:bg1];
    [self.view bringSubviewToFront:self.bar];
}

- (UILabel *)warningLabel {
    if (!_warningLabel) {
        _warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, gScreenWidth, 30)];
        _warningLabel.backgroundColor = _warningColor;
        _warningLabel.font = [UIFont systemFontOfSize:14];
        _warningLabel.textColor = [UIColor colorWithRed:223/255.0 green:74/255.0 blue:44/255.0 alpha:1.0];
        _warningLabel.text = @"     单个红包数目不能超过200元";
        [self.view insertSubview:_warningLabel belowSubview:self.bar];
    }
    return _warningLabel;
}

- (void)showWarning{
    if (CGRectGetMaxY(self.warningLabel.frame) == CGRectGetMaxY(self.bar.frame)) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.warningLabel.frame = CGRectMake(0, CGRectGetMaxY(self.bar.frame), gScreenWidth, 30);
    }];
}

- (void)hiddenWarning{
    if (CGRectGetMaxY(self.warningLabel.frame) <= CGRectGetMaxY(self.bar.frame)) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.warningLabel.frame = CGRectMake(0, 10, gScreenWidth, 30);
    }];
}

@end
