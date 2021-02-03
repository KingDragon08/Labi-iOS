//
//  BaseMoneyViewController.m
//  WFChatUIKit
//
//  Created by xxx on 2019/11/20.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "BaseMoneyViewController.h"

@interface BaseMoneyViewController ()

@end

@implementation BaseMoneyViewController

- (instancetype)init{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"Dealloc____%@",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)backCLick{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self dismissViewControllerAnimated:true completion:nil];
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
