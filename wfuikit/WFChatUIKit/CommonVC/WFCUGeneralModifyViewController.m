//
//  GeneralModifyViewController.m
//  WildFireChat
//
//  Created by heavyrain lee on 24/12/2017.
//  Copyright © 2017 WildFireChat. All rights reserved.
//

#import "WFCUGeneralModifyViewController.h"
#import "MBProgressHUD.h"
#import "WFCUConfigManager.h"

@interface WFCUGeneralModifyViewController () <UITextFieldDelegate>
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UILabel *hintLabel;
@end

@implementation WFCUGeneralModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.titleText) {
        [self setTitle:_titleText];
    }
    
    self.textField.text = self.defaultValue;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:WFCString(@"Cancel") style:UIBarButtonItemStyleDone target:self action:@selector(onCancel:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:WFCString(@"Done") style:UIBarButtonItemStyleDone target:self action:@selector(onDone:)];
    
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName: [UIFont boldSystemFontOfSize:16]}forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:239/255.0 blue:240/255.0 alpha:1.0];
    [self.textField becomeFirstResponder];
}

- (void)onCancel:(id)sender {
  [self.textField resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)onDone:(id)sender {
  [self.textField resignFirstResponder];
    __weak typeof(self) ws = self;
    
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = WFCString(@"Updating");
    [hud showAnimated:YES];
    
    self.tryModify(self.textField.text, ^(BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:NO];
            if(success) {
                [ws.navigationController dismissViewControllerAnimated:YES completion:nil];
            } else {
                hud = [MBProgressHUD showHUDAddedTo:ws.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = WFCString(@"UpdateFailure");
                hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                [hud hideAnimated:YES afterDelay:1.f];
            }
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITextField *)textField {
    if(!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight + 20, [UIScreen mainScreen].bounds.size.width, 52)];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        _textField.delegate = self;
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
        //设置显示模式为永远显示(默认不显示)
        _textField.leftViewMode = UITextFieldViewModeAlways;
        [self.view addSubview:_textField];
    }
    return _textField;
}

- (UILabel *)hintLabel {
    if(!_hintLabel) {
        _hintLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, kStatusBarAndNavigationBarHeight + 20 + 53, [UIScreen mainScreen].bounds.size.width - 20, 35)];
//        _hintLabel.text = @"在这里可以设置你在这个群里的昵称，这个昵称只会在此群内显示。";
        _hintLabel.font = [UIFont systemFontOfSize:13];
        _hintLabel.textColor = [UIColor colorWithRed:165/255.0 green:166/255.0 blue:167/255.0 alpha:1.0];
        _hintLabel.numberOfLines = 0;
        [self.view addSubview:_hintLabel];
    }
    return _hintLabel;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self onDone:textField];
    return YES;
}
@end
