//
//  ADDetailViewController.m
//  WildFireChat
//
//  xxxxx on 2018/11/28.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "ADDetailViewController.h"
#import <WebKit/WebKit.h>

@interface ADDetailViewController ()

@end

@implementation ADDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUrl:(NSURL *)url {
    WKWebView *ww = [[WKWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:ww];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [ww loadRequest:request];
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
