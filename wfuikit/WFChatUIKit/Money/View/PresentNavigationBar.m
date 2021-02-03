//
//  PresentNavigationBar.m
//  WFChatUIKit
//
//  Created by xxx on 2019/11/20.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "PresentNavigationBar.h"
#import "Predefine.h"

@implementation PresentNavigationBar

- (instancetype)init{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)setLeftTitle{
    [self.backBtn setHidden:NO];
    [self.lineView setHidden:YES];
    [self.backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.backBtn setImage:nil forState:UIControlStateNormal];
}

- (void)showBackImage {
    [self.backBtn setHidden:NO];
    [self.backBtn setImage:[UIImage imageNamed:@"transfer_detail_back"] forState:UIControlStateNormal];
    self.backBtn.frame = CGRectMake(-5, 0, 50, self.contentView.bounds.size.height);
}

- (void)initUI{
    CGFloat gTitleBarHeightWithoutStartusBar = 45;
    CGFloat topMargin = gSafeAreaInsets.top;
    CGFloat titleBarheight = topMargin + gTitleBarHeightWithoutStartusBar;
    self.backgroundColor = [UIColor colorWithRed:236/255.0 green:237/255.0 blue:238/255.0 alpha:1];
    self.frame = CGRectMake(0, 0, gScreenWidth, titleBarheight);
    
    self.contentView = [UIView new];
    self.contentView.frame = CGRectMake(0, topMargin, gScreenWidth, gTitleBarHeightWithoutStartusBar);
    [self addSubview:self.contentView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.frame = CGRectMake(40, 0, gScreenWidth - 80, self.contentView.frame.size.height);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    if (@available(iOS 8.2, *)) {
        self.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    } else {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    [self.contentView addSubview:self.titleLabel];
    
    self.backBtn = [[UIButton alloc] init];
    self.backBtn.frame = CGRectMake(5, 0, 50, self.contentView.bounds.size.height);
    [self.backBtn setImage:[UIImage imageNamed:@"transfer_detail_back"] forState:UIControlStateNormal];
    [self.backBtn setImage:[UIImage imageNamed:@"transfer_detail_back"] forState:UIControlStateHighlighted];
    [self.backBtn setHidden:YES];
    self.backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.contentView addSubview:self.backBtn];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, gScreenWidth, 0.5)];
    self.lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [self addSubview:self.lineView];
    self.lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

- (UIViewController *)viewController{
    UIResponder *parentResponder = self;
    while (parentResponder != nil) {
        parentResponder = parentResponder.nextResponder;
        if ([parentResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)parentResponder;
        }
    }
    return nil;
}

@end
