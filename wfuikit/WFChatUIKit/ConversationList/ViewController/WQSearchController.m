//
//  WQSearchController.m
//  WFChatUIKit
//
//    on 2019/11/4.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "WQSearchController.h"

@interface WQSearchController ()

@end

@implementation WQSearchController

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

@end
