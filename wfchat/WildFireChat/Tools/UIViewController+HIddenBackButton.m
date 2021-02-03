//
//  UIViewController+HIddenBackButton.m
//  WildFireChat
//
//  2019/10/31.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import "UIViewController+HIddenBackButton.h"
#import <objc/runtime.h>

@implementation UIViewController (HIddenBackButton)

+(void)load{
    [UIViewController exchange];
}

+ (void)exchange{
    Method m1 = class_getInstanceMethod(UIViewController.class, @selector(viewDidLoad));
    Method m2 = class_getInstanceMethod(self, @selector(fy_viewDidload));
    NSLog(@"viewDidLoad excheng before:%p",method_getImplementation(m1));
    NSLog(@"fy_viewDidload excheng before:%p",method_getImplementation(m2));
    if (!class_addMethod(self, @selector(fy_viewDidload), method_getImplementation(m2), method_getTypeEncoding(m2))) {
        method_exchangeImplementations(m1, m2);
    }
    NSLog(@"viewDidLoad excheng after:%p",method_getImplementation(m1));
    NSLog(@"fy_viewDidload excheng after:%p",method_getImplementation(m2));
}

+ (void)fy_viewDidload {
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self fy_viewDidload];
}

@end
