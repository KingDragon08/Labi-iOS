//
//  BindCardViewController.m
//  WildFireChat
//
//  Created by xxx on 2018/12/12.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "BindCardViewController.h"
#import "MBProgressHUD.h"

@interface BindCardViewController ()
@property (weak, nonatomic) IBOutlet UITextField *cardLabel;
@property (weak, nonatomic) IBOutlet UITextField *bankField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation BindCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cardLabel.placeholder = LocalizedString(@"Card Num");
    [self.sureBtn setTitle:LocalizedString(@"Submit") forState:UIControlStateNormal];
    self.hintLabel.text = LocalizedString(@"BindCard");
    self.bankField.placeholder = LocalizedString(@"BankName");
    self.nameField.placeholder = LocalizedString(@"UserName");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)sureclick:(id)sender {
    
    if (self.cardLabel.text.length <= 0) {
        [MBProgressHUD showHUDText:LocalizedString(@"Card Num") addedTo:self.view];
        return;
    }
    
    if (self.bankField.text.length <= 0) {
        [MBProgressHUD showHUDText:LocalizedString(@"BankName") addedTo:self.view];
        return;
    }
    
    if (self.nameField.text.length <= 0) {
        [MBProgressHUD showHUDText:LocalizedString(@"UserName") addedTo:self.view];
        return;
    }
    
    [self.view endEditing:YES];
    NSString *sn = [WFCCNetworkService sharedInstance].userId;
    NSDictionary *param = @{@"userId": sn, @"card":self.cardLabel.text, @"bank": self.bankField.text, @"rname": self.nameField.text};
    [[NetworkAPI sharedInstance] v2GetWithUrl:APP_bindBankCard params: param successComplection:^(NSDictionary * _Nonnull done) {
        [MBProgressHUD showHUDText:@"success" addedTo:self.view];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.block) {
            self.block();
        }
    } failureComplection:^(NSDictionary * _Nonnull done) {
        [MBProgressHUD showHUDText:done[@"msg"] addedTo:self.view];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
