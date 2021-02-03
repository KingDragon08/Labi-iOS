//
//  AlterViewController.m
//  WildFireChat
//
//  Created by xxx on 2018/12/11.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "AlterViewController.h"
#import <WFChatClient/WFCChatClient.h>
#import "SDWebImage.h"
#import <WFChatUIKit/WFChatUIKit.h>
#import "WFCSettingTableViewController.h"
#import "WFCSecurityTableViewController.h"
#import "WFCMeTableViewCell.h"
#import "WFCInfoTableViewCell.h"
#import "WFUserModel.h"
#import "MBProgressHUD.h"

@interface AlterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UITextField *field1;
@property (weak, nonatomic) IBOutlet UITextField *field2;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation AlterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self languageLabel];
}

- (void)languageLabel {
    self.label1.text = LocalizedString(@"OriginalPassword");
    self.label2.text = LocalizedString(@"NewPassword");
    self.field1.placeholder = LocalizedString(@"OriginalPassword");
    self.field2.placeholder = LocalizedString(@"NewPassword");
    [self.btn setTitle:LocalizedString(@"Submit") forState:UIControlStateNormal];
}

- (IBAction)sure:(id)sender {
    if(self.field1.text <= 0) {
        return;
    }
    
    if (self.field2.text <= 0) {
        return;
    }
    NSString *sn = [WFCCNetworkService sharedInstance].userId;
    NSDictionary *dic = @{@"userId": sn, @"id":sn,@"oldPw": self.field1.text, @"newPw": self.field2.text};
    [[NetworkAPI sharedInstance] postWithUrl:APP_ChangePassword params:dic successComplection:^(NSDictionary * _Nonnull done) {
        [MBProgressHUD showHUDText:@"success" addedTo:self.view];
        [self.navigationController popViewControllerAnimated:YES];
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
