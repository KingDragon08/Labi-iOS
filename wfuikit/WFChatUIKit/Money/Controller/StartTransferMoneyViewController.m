//
//  StartTransferMoneyViewController.m
//  WFChatClient
//
//  Created by xxx on 2019/11/20.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import "StartTransferMoneyViewController.h"
#import "SDWebImage.h"
#import "LEEAlert.h"
#import "NetworkAPI.h"
#import "MBProgressHUD.h"
#import "ToastManager.h"

@interface StartTransferMoneyViewController ()<UITextFieldDelegate,InputPasswordDelegate,XWMoneyTextFieldLimitDelegate>

@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, assign) long long totalMoney;
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation StartTransferMoneyViewController {
    NSString *_note;
    XWMoneyTextField *moneyField;
    NSString *_initNote;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    NSString *targetName;
    if (self.targetUser.friendAlias.length > 0) {
        targetName = self.targetUser.friendAlias;
    } else if (self.targetUser.displayName.length > 0) {
        targetName = self.targetUser.displayName;
    } else {
        targetName = self.targetUser.name;
    }
    _initNote = [NSString stringWithFormat:@"转账"];
}

- (void)sureBtnCLick{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:4];
    if (!moneyField.text | (moneyField.text.length == 0) | [moneyField.text isEqualToString:@"0"]| [moneyField.text isEqualToString:@"0.0"]| [moneyField.text isEqualToString:@"0."]) {
        return;
    }
    
    NSString *str = [NSString stringWithFormat:@"%.2f",[moneyField.text doubleValue]];
    [param setValue:[[WFCCNetworkService sharedInstance] userId] forKey:@"userId"];
    [param setValue:@"userId" forKey:@"payNumber"];
    [param setValue:@"" forKey:@"money"];
    [param setValue:self.targetUser.userId forKey:@"targetUserId"];
    
    if (_note != nil && _note.length > 0 ) {
        [param setValue:_note forKey:@"note"];
    } else {
        [param setValue:_initNote forKey:@"note"];
    }
    NSString *typeStr = [NSString stringWithFormat:@"向%@发起转账",self.targetUser.name];
    InputPasswordView *input = [InputPasswordView showPassword:typeStr money:str withDelegate:self];
    [input.pwdTextField becomeFirstResponder];
}

- (void)inputDone:(NSString *)password {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:4];
    if (!moneyField.text | (moneyField.text.length == 0) | [moneyField.text isEqualToString:@"0"]| [moneyField.text isEqualToString:@"0.0"]| [moneyField.text isEqualToString:@"0."]) {
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%.2f",[moneyField.text doubleValue]];
    NSString *fen = [NSString stringWithFormat:@"%.0f",[str doubleValue] *100];
    [param setValue:[[WFCCNetworkService sharedInstance] userId] forKey:@"userId"];
    [param setValue:password forKey:@"payNumber"];
    [param setValue:fen forKey:@"money"];
    [param setValue:self.targetUser.userId forKey:@"targetUserId"];
    
    if (_note != nil && _note.length > 0 ) {
        [param setValue:_note forKey:@"note"];
    } else {
        [param setValue:_initNote forKey:@"note"];
    }
    
    [ToastManager showText:@"" inView:self.view];
    [[NetworkAPI sharedInstance] postWithUrl:MONEY_TRANSFER_SEND params:param successComplection:^(NSDictionary * _Nonnull done) {
        LuckyMoneyListModel *lModel = [LuckyMoneyListModel mj_objectWithKeyValues:done[@"data"]];
        MessageContentModel *mModel = [[MessageContentModel alloc] init];
        mModel.redPId = lModel.redPId;
        mModel.money = fen;
        mModel.type = MONEY_TRANSFER;
        mModel.status = MONEY_STATE_NORMAL;
        mModel.note = param[@"note"];
        if (self.block){
            self.block(mModel.mj_JSONString);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } failureComplection:^(NSDictionary * _Nonnull done) {
        [ToastManager showToast:done[@"msg"] inView:self.view];
    }];
}

- (void)textDidChange:(UITextField *)field{
    if (field.text != nil && field.text.length > 0 && (![field.text isEqualToString:@" "]) && [field.text intValue] > 0) {
        self.sureBtn.enabled = YES;
        self.sureBtn.alpha = 1;
    } else {
        self.sureBtn.enabled = NO;
        self.sureBtn.alpha = 0.4;
    }
}

- (void)writeNote{
    __block NSString *temp = _note;
    __block UITextField *tf = nil;
    [LEEAlert alert].config
    .LeeTitle(@"转账说明")
    .LeeAddTextField(^(UITextField *textField) {
        // 这里可以进行自定义的设置
        textField.placeholder = @"收款方可见，最多10个字";
        textField.textColor = [UIColor darkGrayColor];
        tf = textField;
    })
    .LeeAction(@"确定", ^{
        temp = tf.text;
    })
    .LeeCancelAction(@"取消", nil) // 点击事件的Block如果不需要可以传nil
    .LeeShow();
}

- (void)initUI {
    self.bar = [[PresentNavigationBar alloc] init];
    [self.bar.backBtn addTarget:self action:@selector(backCLick) forControlEvents:UIControlEventTouchUpInside];
    [self.bar showBackImage];
    [self.bar.lineView setHidden:YES];
    [self.view addSubview:self.bar];
    
    self.view.backgroundColor = self.bar.backgroundColor;
    
    CGFloat kWidth = self.view.frame.size.width;
    CGFloat kheight = self.view.frame.size.height;
    
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:237/255.0 blue:238/255.0 alpha:1];
    self.headerImage = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth - 36)/2, 10 + kSafeBarHeight, 36, 36)];
    self.headerImage.layer.cornerRadius = 3.0;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[self.targetUser.portrait stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"PersonalChat"]];
    UILabel *nameLabel  = [[UILabel alloc] initWithFrame:CGRectMake((kWidth - 150)/2, CGRectGetMaxY(self.headerImage.frame) + 10, 150, 25)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = self.targetUser.displayName;
    nameLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [self.view addSubview:self.headerImage];
    [self.view addSubview:nameLabel];
    
    UIView *white = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLabel.frame) + 20, kWidth, kheight - 50)];
    white.backgroundColor = [UIColor whiteColor];
    white.layer.cornerRadius = 5.0;
    [self.view addSubview:white];
    
    UILabel *hintMoneyLabel  = [[UILabel alloc] initWithFrame:CGRectMake(28, 28, 100, 15)];
    hintMoneyLabel.text = @"转账金额";
    hintMoneyLabel.font = [UIFont systemFontOfSize:14];
    
    UILabel *yuanLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 40)];
    yuanLabel.textAlignment = NSTextAlignmentLeft;
    yuanLabel.text = @"¥";
    yuanLabel.font = WechatFont(50);
    
    XWMoneyTextField *field = [[XWMoneyTextField alloc] initWithFrame:CGRectMake(28, CGRectGetMaxY(hintMoneyLabel.frame) + 20, kWidth - 58, 50)];
    field.font = WechatFont(50);
    field.leftView = yuanLabel;
    field.keyboardType = UIKeyboardTypeDecimalPad;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.limit.delegate = self;
    field.limit.max = @"999999.99";
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(28, CGRectGetMaxY(field.frame) + 5, kWidth - 56, WFCCUtilities.onepxLine)];
    line.backgroundColor = WFCCUtilities.onePxLineColor;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(line.frame) + 20, 100, 40)];
    [btn setTitle:@"填写转账说明" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor colorWithRed:20/255.0 green:50/255.0 blue:114/255.0 alpha:1] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(writeNote) forControlEvents:UIControlEventTouchUpInside];
    
    [white addSubview:hintMoneyLabel];
    [white addSubview:field];
    [white addSubview:line];
    [white addSubview:btn];
    
    self.sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(btn.frame) + 30, kWidth - 100, 50)];
    [self.sureBtn setBackgroundColor: HEXCOLOR(0x56BE6A)];
    
    self.sureBtn.enabled = false;
    [self.sureBtn addTarget:self action:@selector(sureBtnCLick) forControlEvents:UIControlEventTouchDown];
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 5.f;
    [self.sureBtn setTitle:@"确认转账" forState:UIControlStateNormal];
    self.sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.sureBtn.enabled = NO;
    self.sureBtn.alpha = 0.4;
    [white addSubview:self.sureBtn];
    moneyField = field;
}

// MARK: 输入框变化时
- (void)inputValueChange:(id)sender {
    if ([sender isKindOfClass:[XWMoneyTextField class]]) {
        XWMoneyTextField *field = (XWMoneyTextField *)sender;
        if (field.text != nil && field.text.length > 0 && (![field.text isEqualToString:@"0"])&& (![field.text isEqualToString:@"0."])&& (![field.text isEqualToString:@"0.0"])) {
            self.sureBtn.enabled = YES;
            self.sureBtn.alpha = 1;
        } else {
            self.sureBtn.enabled = NO;
            self.sureBtn.alpha = 0.4;
        }
    }
}

@end
