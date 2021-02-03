//
//  CustomImagePickerController.m
//  WildFireChat
//
//  2019/11/1.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import "CustomImagePickerController.h"

@interface CustomImagePickerController ()

@end

@implementation CustomImagePickerController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName: [UIFont boldSystemFontOfSize:15]}forState:UIControlStateNormal];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor],NSFontAttributeName: [UIFont systemFontOfSize:0.1]}forState:UIControlStateNormal];
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
