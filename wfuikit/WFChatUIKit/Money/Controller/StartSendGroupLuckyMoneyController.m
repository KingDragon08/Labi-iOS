//
//  StartSendGroupLuckyMoneyController.m
//  WFChatUIKit
//
//  Created by xxx on 2019/11/20.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "StartSendGroupLuckyMoneyController.h"
#import "ContactListViewController.h"
@interface StartSendGroupLuckyMoneyController ()<UITextFieldDelegate,InputPasswordDelegate,XWMoneyTextFieldLimitDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *bgScroll;
@property (nonatomic, strong) XWMoneyTextField *moneyField;
@property (nonatomic, strong) UITextField *numberField;
@property (nonatomic, strong) UITextField *noteField;

@property (nonatomic, strong) UIView *randomBg;
@property (nonatomic, strong) UIButton *changeBtn;

@property (nonatomic, strong) UIView *averageBg;
@property (nonatomic, strong) XWMoneyTextField *randomMoneyField;

@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *warningLabel;
@property (nonatomic, strong) NSMutableArray <WFCCUserInfo *>* allUsers;
@property (nonatomic, strong) NSMutableSet <NSString *>* allUserIds;

@property (nonatomic, strong) UIView *selectUsers;
@property (nonatomic, strong) UILabel *usersCount;

@end

@implementation StartSendGroupLuckyMoneyController {
    UIColor *_warningColor;
    CGFloat _topMargin;
    NSInteger _totalCount;
    /// 默认为拼手气红包
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

// MARK: 输入框变化时
- (void)inputValueChange:(id)sender {
    if ([sender isKindOfClass:[XWMoneyTextField class]]) {
        [self updateMakesureBtn];
    }
}

- (void)updateMakesureBtn {
    XWMoneyTextField *field = self.randomMoneyField;
    BOOL isRandom = self.changeBtn.selected;
    if (isRandom) {
        field = self.moneyField;
    }
    if ((field.text != nil && field.text.length > 0 && (![field.text isEqualToString:@"0"])&& (![field.text isEqualToString:@"0."])&& (![field.text isEqualToString:@"0.0"]) && ([self.numberField.text integerValue] > 0)) && (self.allUserIds.count > 0)){
        self.sendBtn.enabled = YES;
        self.sendBtn.alpha = 1;
    } else {
        self.sendBtn.enabled = NO;
        self.sendBtn.alpha = 0.4;
    }
    double count = self.numberField.text ? self.numberField.text.doubleValue : 0;
    if (isRandom) {
        self.moneyLabel.text = [[NSString alloc] initWithFormat:@"¥%.2f",[field.text doubleValue]];
        if ((([field.text doubleValue] - count * 200.0 <= 0) || count == 0) &&(self.allUserIds.count > 0)) {
            [self hiddenWarning];
            self.sendBtn.enabled = YES;
            self.sendBtn.alpha = 1;
        } else {
            [self showWarning];
            self.sendBtn.enabled = NO;
            self.sendBtn.alpha = 0.4;
        }
    } else {
        self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.numberField.text doubleValue] * [field.text doubleValue]];
        if ((([field.text doubleValue] - count * 200.0 <= 0) || (count == 0)) && (self.allUserIds.count > 0)) {
            [self hiddenWarning];
            self.sendBtn.enabled = YES;
            self.sendBtn.alpha = 1;
        } else {
            [self showWarning];
            self.sendBtn.enabled = NO;
            self.sendBtn.alpha = 0.4;
        }
    }
}

- (void)inputDone:(NSString *)password {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:4];
    XWMoneyTextField *targetfield;
    BOOL isRandom = self.changeBtn.isSelected;
    if (isRandom) {
        targetfield = self.moneyField;
    } else {
        targetfield = self.randomMoneyField;
    }
    if (!targetfield.text | (targetfield.text.length == 0) | [targetfield.text isEqualToString:@"0"]| [targetfield.text isEqualToString:@"0.0"]| [targetfield.text isEqualToString:@"0."]) {
        return;
    }
    if (!self.numberField.text | (self.numberField.text.length == 0) | [self.numberField.text isEqualToString:@"0"]| [self.numberField.text integerValue] == 0) {
        return;
    }
    NSString *money;
    if (isRandom) {
        money = [[NSString alloc] initWithFormat:@"%.2f",[targetfield.text doubleValue]];
        param[@"type"] = @"0";
    } else {
        money = [NSString stringWithFormat:@"%.2f",[self.numberField.text doubleValue] * [targetfield.text doubleValue]];
        param[@"type"] = @"1";
    }
    NSString *str = [NSString stringWithFormat:@"%.2f",[money doubleValue]];
    NSString *fen = [NSString stringWithFormat:@"%.0f",[str doubleValue] *100];
    [param setValue:[[WFCCNetworkService sharedInstance] userId] forKey:@"userId"];
    [param setValue:password forKey:@"payNumber"];
    [param setValue:fen forKey:@"money"];
    [param setValue:self.numberField.text forKey:@"number"];
    /// target_type: 0-single 1-agroup
    [param setValue:@"1" forKey:@"targetType"];
    NSArray *userSets = [self.allUserIds allObjects];
    NSString *ids = [userSets componentsJoinedByString:@","];
    [param setValue:ids forKey:@"targetId"];
    
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
        mModel.type = 3;
        if (self.block){
            self.block(mModel.mj_JSONString);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } failureComplection:^(NSDictionary * _Nonnull done) {
        [ToastManager showToast:done[@"msg"] inView:self.view];
    }];
}

- (void)sureBtnCLick{
    XWMoneyTextField *targetfield;
    BOOL isRandom = self.changeBtn.isSelected;
    if (isRandom) {
        targetfield = self.moneyField;
    } else {
        targetfield = self.randomMoneyField;
    }
    if (!targetfield.text | (targetfield.text.length == 0) | [targetfield.text isEqualToString:@"0"]| [targetfield.text isEqualToString:@"0.0"]| [targetfield.text isEqualToString:@"0."]) {
        return;
    }
    if (!self.numberField.text | (self.numberField.text.length == 0) | [self.numberField.text isEqualToString:@"0"]| [self.numberField.text integerValue] == 0) {
        return;
    }
    NSString *money = self.randomMoneyField.text;
    
    if (self.changeBtn.isSelected) {
        money = [[NSString alloc] initWithFormat:@"%.2f",[self.moneyField.text doubleValue]];
    } else {
        money = [NSString stringWithFormat:@"%.2f",[self.numberField.text doubleValue] * [targetfield.text doubleValue] * 1.00];
    }
    NSString *typeStr = [NSString stringWithFormat:@"微信红包"];
    InputPasswordView *input = [InputPasswordView showPassword:typeStr money:money withDelegate:self];
    [input.pwdTextField becomeFirstResponder];
}

- (void)changeWay {
    [self.changeBtn setSelected:!self.changeBtn.isSelected];
    
    if (!self.changeBtn.isSelected) {
        /// avera
        [UIView animateWithDuration:0.25 animations:^{
            self.averageBg.frame = CGRectMake(20, 0, gScreenWidth - 40, 52);
            self.randomBg.frame = CGRectMake(- gScreenWidth, 0, gScreenWidth - 40, 52);
        } completion:^(BOOL finished) {
            self.randomBg.frame = CGRectMake(gScreenWidth, 0, gScreenWidth - 40, 52);
            [self.moneyField setText:nil];
            [self updateMakesureBtn];
        }];
    } else {
        /// random
        [UIView animateWithDuration:0.25 animations:^{
            self.randomBg.frame = CGRectMake(20, 0, gScreenWidth - 40, 52);
            self.averageBg.frame = CGRectMake(- gScreenWidth, 0, gScreenWidth - 40, 52);
        } completion:^(BOOL finished) {
            self.averageBg.frame = CGRectMake(gScreenWidth, 0, gScreenWidth - 40, 52);
            [self.randomMoneyField setText:nil];
            [self updateMakesureBtn];
        }];
    }
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
// MARK: 确定之后更新选中的数据
- (void) updateSelects:(NSMutableSet <NSString*> *)selects {
    self.allUserIds = selects;
    self.usersCount.textColor = [UIColor blackColor];
    if (self.allUserIds.count == _totalCount && self.allUserIds.count !=0) {
        self.usersCount.text = [NSString stringWithFormat:@"全部可领"];
    } else if (self.allUserIds.count == 0) {
        self.usersCount.text = [NSString stringWithFormat:@"请指定领取人"];
        self.usersCount.textColor = [UIColor grayColor];
    } else {
        self.usersCount.text = [NSString stringWithFormat:@"%ld人",self.allUserIds.count];
    }
    [self updateMakesureBtn];
}
// MARK: 点击选择时进入选择页面
- (void)selectTargetUsers {
    ContactListViewController *vc = [[ContactListViewController alloc] init];
    vc.agroupId = self.agroupId;
    vc.cv = self;
    vc.selects = self.allUserIds;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)textValueDidChange {
    [self updateMakesureBtn];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.numberField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            [self updateMakesureBtn];
            return YES;
        } else if (self.numberField.text.length >= 3) {
            self.numberField.text = [textField.text substringToIndex:3];
            return NO;
        }
    }
    return YES;
}

- (void)tapGesture {
    [self.view endEditing:YES];
}

- (void)initUI {
    
    NSArray *users = [[WFCCIMService sharedWFCIMService] getGroupMembers:self.agroupId forceUpdate:YES];
    self.allUserIds = [[NSMutableSet alloc] init];
    for (WFCCGroupMember *user in users) {
        [self.allUserIds addObject:user.memberId];
    }
    _totalCount = self.allUsers.count;
    self.bar = [[PresentNavigationBar alloc] init];
    [self.bar.backBtn addTarget:self action:@selector(backCLick) forControlEvents:UIControlEventTouchUpInside];
    [self.bar setLeftTitle];
    self.bar.titleLabel.text = @"发红包";
    [self.view addSubview:self.bar];
    self.view.backgroundColor = self.bar.backgroundColor;
    
    self.bgScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.bar.frame.size.height + 20, gScreenWidth, gScreenHeight-50)];
    self.bgScroll.scrollEnabled = YES;
    self.bgScroll.showsVerticalScrollIndicator = NO;
    self.bgScroll.contentSize = CGSizeMake(0, gScreenHeight);
    [self.view addSubview:self.bgScroll];
    
    _topMargin = self.bar.frame.size.height + 20;
    _warningColor = [UIColor colorWithRed:227/255.0 green:194/255.0 blue:137/255.0 alpha:1.0];
    
    UIView *bg1 = [[UIView alloc] initWithFrame:CGRectMake(20, 0, gScreenWidth - 40, 52)];
    bg1.backgroundColor = [UIColor whiteColor];
    bg1.layer.cornerRadius = 4.0;
    
    UIImageView *pin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LuckyMoney_Pin"]];
    [bg1 addSubview:pin];
    pin.frame = CGRectMake(10, 18.5, 15, 15);
    UILabel *jine = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 60, 52)];
    jine.font = [UIFont systemFontOfSize:16];
    jine.text = @"总金额";
    [bg1 addSubview:jine];
    
    UILabel *yuan = [[UILabel alloc] initWithFrame:CGRectMake(gScreenWidth - 40 - 30, 0, 20, 52)];
    yuan.font = [UIFont systemFontOfSize:16];
    yuan.text = @"元";
    [bg1 addSubview:yuan];
    
    self.moneyField = [[XWMoneyTextField alloc] init];
    self.moneyField.frame = CGRectMake(96, 0,gScreenWidth - 40-96 - 40 , 52);
    self.moneyField.textAlignment = NSTextAlignmentRight;
    self.moneyField.placeholder = @"0.00";
    self.moneyField.limit.delegate = self;
    [bg1 addSubview:self.moneyField];
    
    [self.bgScroll addSubview:bg1];
    self.randomBg = bg1;
    
    UILabel *cLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(bg1.frame) + 8, 110, 12)];
    cLabel.font = [UIFont systemFontOfSize:12.0];
    cLabel.textColor = [UIColor grayColor];
    cLabel.text = @"当前为拼手气红包,";
    [self.bgScroll addSubview:cLabel];
    self.changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cLabel.frame), CGRectGetMaxY(bg1.frame) + 8, 90, 12)];
    [self.changeBtn setTitleColor:_warningColor forState:UIControlStateNormal];
    self.changeBtn.titleLabel.font = cLabel.font;
    [self.changeBtn setTitle:@"改为普通红包" forState:UIControlStateNormal];
    [self.changeBtn addTarget:self action:@selector(changeWay) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScroll addSubview:self.changeBtn];
    self.bgScroll.delegate = self;
    
    UIView *countBg = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(bg1.frame) + 40, gScreenWidth - 40, 52)];
    countBg.backgroundColor = [UIColor whiteColor];
    countBg.layer.cornerRadius = 4.0;
    
    UILabel *geshu = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 52)];
    geshu.font = [UIFont systemFontOfSize:16];
    geshu.text = @"红包个数";
    [countBg addSubview:geshu];
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(gScreenWidth - 40 - 30, 0, 20, 52)];
    countLabel.font = [UIFont systemFontOfSize:16];
    countLabel.text = @"个";
    [countBg addSubview:countLabel];
    
    self.numberField = [[UITextField alloc] init];
    self.numberField.frame = CGRectMake(96, 0,gScreenWidth - 40-96 - 40 , 52);
    self.numberField.textAlignment = NSTextAlignmentRight;
    self.numberField.keyboardType = UIKeyboardTypeNumberPad;
    self.numberField.placeholder = @"填写个数";
    self.numberField.delegate = self;
    [self.numberField addTarget:self action:@selector(textValueDidChange) forControlEvents:UIControlEventEditingChanged];
    [countBg addSubview:self.numberField];
    [self.bgScroll addSubview:countBg];
    
    UILabel *c2Label = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(countBg.frame) + 8, 100, 12)];
    c2Label.font = cLabel.font;
    c2Label.textColor = [UIColor grayColor];
    c2Label.text = [NSString stringWithFormat:@"本群共%ld人",self.allUserIds.count];
    [self.bgScroll addSubview:c2Label];
    
    UIView *bg2 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(countBg.frame)+ 40, gScreenWidth - 40, 52)];
    self.noteField = [[UITextField alloc] init];
    self.noteField.frame = CGRectMake(10, 0, gScreenWidth - 80, 52);
    self.noteField.textAlignment = NSTextAlignmentLeft;
    self.noteField.placeholder = @"恭喜发财,大吉大利";
    bg2.backgroundColor = bg1.backgroundColor;
    bg2.layer.cornerRadius = bg1.layer.cornerRadius;
    [bg2 addSubview:self.noteField];
    [self.bgScroll addSubview:bg2];
    
    self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 , CGRectGetMaxY(bg2.frame) + 90, gScreenWidth - 60, 45)];
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    self.moneyLabel.font = WechatFont(50);
    self.moneyLabel.text = @"¥0.00";
    [self.bgScroll addSubview:self.moneyLabel];
    
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
    [self.bgScroll addSubview:self.sendBtn];
    
    UILabel *hint = [[UILabel alloc] init];
    hint.text = @"未领取的红包，将在24小时后发起退款";
    hint.font = [UIFont systemFontOfSize:12];
    hint.textAlignment = NSTextAlignmentCenter;
    hint.textColor = [UIColor grayColor];
    hint.frame = CGRectMake(40, gScreenHeight - gSafeAreaInsets.bottom - 40, gScreenWidth - 80, 20);
    [self.bgScroll addSubview:hint];
    [self.view insertSubview:self.warningLabel aboveSubview:bg1];
    [self.view bringSubviewToFront:self.bar];
    [self.changeBtn setSelected:YES];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
    [self.bgScroll addSubview:self.selectUsers];
    [self updateSelects:self.allUserIds];
}

- (UIView *)averageBg {
    if (!_averageBg) {
        UIView *bg1 = [[UIView alloc] initWithFrame:CGRectMake(gScreenWidth, 0, gScreenWidth - 40, 52)];
        bg1.backgroundColor = [UIColor whiteColor];
        bg1.layer.cornerRadius = 4.0;
        UILabel *jine = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 52)];
        jine.font = [UIFont systemFontOfSize:16];
        jine.textAlignment = NSTextAlignmentLeft;
        jine.text = @"单个金额";
        [bg1 addSubview:jine];
        
        UILabel *yuan = [[UILabel alloc] initWithFrame:CGRectMake(gScreenWidth - 40 - 30, 0, 20, 52)];
        yuan.font = [UIFont systemFontOfSize:16];
        yuan.text = @"元";
        [bg1 addSubview:yuan];
        
        self.randomMoneyField = [[XWMoneyTextField alloc] init];
        self.randomMoneyField.frame = CGRectMake(96, 0,gScreenWidth - 40-96 - 40 , 52);
        self.randomMoneyField.textAlignment = NSTextAlignmentRight;
        self.randomMoneyField.placeholder = @"0.00";
        self.randomMoneyField.limit.delegate = self;
        [bg1 addSubview:self.randomMoneyField];
        [self.bgScroll addSubview:bg1];
        _averageBg = bg1;
    }
    return _averageBg;
}

- (UILabel *)warningLabel {
    if (!_warningLabel) {
        _warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, gScreenWidth, 30)];
        _warningLabel.backgroundColor = _warningColor;
        _warningLabel.textColor = [UIColor colorWithRed:223/255.0 green:74/255.0 blue:44/255.0 alpha:1.0];
        _warningLabel.text = @"     单个红包数目不能超过200元";
        _warningLabel.font = [UIFont systemFontOfSize:14];
        [self.view insertSubview:_warningLabel belowSubview:self.bar];
        [self.view insertSubview:_warningLabel aboveSubview:self.bgScroll];
    }
    return _warningLabel;
}

- (UIView *)selectUsers {
    if (!_selectUsers) {
        UIView *bg = [[UIControl alloc] initWithFrame:CGRectMake(20,CGRectGetMinY(self.moneyLabel.frame) - 52 - 20,gScreenWidth - 40, 52)];
        bg.backgroundColor = [UIColor whiteColor];
        bg.layer.cornerRadius = 4.0;
        bg.userInteractionEnabled = YES;
        UILabel *jine = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 52)];
        jine.font = [UIFont systemFontOfSize:16];
        jine.textAlignment = NSTextAlignmentLeft;
        jine.text = @"指定领取人";
        [bg addSubview:jine];
        
        UIButton *right = [[UIButton alloc] init];
        [right setImage:[UIImage imageNamed:@"select_users_rows"] forState:UIControlStateNormal];
        [right setImage:[UIImage imageNamed:@"select_users_rows"] forState:UIControlStateSelected];
        right.frame = CGRectMake(gScreenWidth - 40 - 100, 0,100 , 52);
        right.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -75);
        [right addTarget:self action:@selector(selectTargetUsers) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:right];
        
        UILabel *selectedCount = [[UILabel alloc] initWithFrame:CGRectMake(gScreenWidth - 40 - 100, 0, 80, 52)];
        selectedCount.font = [UIFont systemFontOfSize:16];
        selectedCount.textAlignment = NSTextAlignmentRight;
        selectedCount.text = @"人";
        [bg addSubview:selectedCount];
        self.usersCount = selectedCount;
        _selectUsers = bg;
    }
    return _selectUsers;
}


@end
