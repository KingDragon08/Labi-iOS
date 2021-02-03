//
//  SecertViewController.m
//  WildFireChat
//
//  Created by  on 2018/1/11.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "SecertViewController.h"
#import <WebKit/WebKit.h>

@interface SecertViewController ()
@property (weak, nonatomic) IBOutlet UIView *bar;

@property (nonatomic, strong) WKWebView *webView;
@end

@implementation SecertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *url = @"https://168ipa.cdn.bcebos.com/secret.html";
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bar.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.bar.frame))];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [self.view addSubview:self.webView];
}

- (IBAction)close:(id)sender {
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
