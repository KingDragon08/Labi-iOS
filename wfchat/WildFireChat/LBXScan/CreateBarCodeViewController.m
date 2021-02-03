//
//  CreateBarCodeViewController.m
//  LBXScanDemo
//
//  Created by lbxia on 2017/1/5.
//  Copyright © 2017年 lbx. All rights reserved.
//

#import "CreateBarCodeViewController.h"
#import "LBXAlertAction.h"
#import "LBXScanNative.h"
#import "UIImageView+CornerRadius.h"
#import <WFChatClient/WFCChatClient.h>
#import <WFChatUIKit/WFChatUIKit.h>

@interface CreateBarCodeViewController ()
@property (nonatomic, strong)UIImageView *logoView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong) UIImageView* logoImgView;

@property (nonatomic, strong) UIView *qrView;
@property (nonatomic, strong) UIImageView* qrImgView;

@property (nonatomic, strong)NSString *qrStr;
@property (nonatomic, strong)NSString *qrLogo;
@property (nonatomic, strong)NSString *labelStr;

@property (nonatomic, strong)WFCCUserInfo *userInfo;
@property (nonatomic, strong)WFCCGroupInfo *groupInfo;
@property (nonatomic, strong) UIView* qrIconView;
@property (nonatomic, strong) UIImageView* qrIconImageView;
@property (nonatomic, strong) UILabel* addressLabel;
@property (nonatomic, strong) UILabel* hintLabel;
@property (nonatomic, strong) UIImageView* maleIcon;

@property (nonatomic, strong)UIActivityIndicatorView *indicatorView;
@end

@implementation CreateBarCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"action_more"] style:UIBarButtonItemStyleDone target:self action:@selector(onRightBtn:)];
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:239/255.0 blue:240/255.0 alpha:1];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    __weak typeof(self) ws = self;
    if (self.qrType == QRType_User) {
        self.qrStr = [NSString stringWithFormat:@"wildfirechat://user/%@", self.target];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:kUserInfoUpdated object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull notification) {
            if ([ws.target isEqualToString:notification.object]) {
                ws.userInfo = notification.userInfo[@"userInfo"];
            }
        }];
        
        self.userInfo = [[WFCCIMService sharedWFCIMService] getUserInfo:[WFCCNetworkService sharedInstance].userId refresh:NO];
    } else if(self.qrType == QRType_Group) {
        self.qrStr = [NSString stringWithFormat:@"wildfirechat://group/%@", self.target];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:kGroupInfoUpdated object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull notification) {
            if ([ws.target isEqualToString:notification.object]) {
                ws.groupInfo = notification.userInfo[@"groupInfo"];
            }
        }];
        
        self.groupInfo = [[WFCCIMService sharedWFCIMService] getGroupInfo:self.target refresh:NO];
    }
    self.qrImgView = [[UIImageView alloc]init];
    _qrImgView.bounds = CGRectMake(0, 0, 280, 280);
    _qrImgView.center = CGPointMake(CGRectGetWidth(self.qrView.frame)/2, CGRectGetHeight(self.qrView.frame)/2+30);
    [self.qrView addSubview:_qrImgView];
    
    [self createQR_logo];
}

- (void)saveImage:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.view.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = @"保存失败";
    } else {
        label.text = @"保存成功";
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}


- (void)onRightBtn:(id)sender {
    [LEEAlert actionsheet].config.LeeDestructiveAction(@"保存图片", ^{
        // 点击事件回调Block
        UIGraphicsBeginImageContext(self.qrView.bounds.size);
        [self.qrView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self saveImage:image];
        
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        action.title = @"取消";
        action.titleColor = [UIColor blackColor];
        action.font = [UIFont systemFontOfSize:17.0f];
    })
    .LeeActionSheetCancelActionSpaceColor([WFCUConfigManager globalManager].backgroudColor) // 设置取消按钮间隔的颜色
    .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
    .LeeCornerRadii(CornerRadiiMake(10, 10, 0, 0))   // 指定整体圆角半径
    .LeeActionSheetHeaderCornerRadii(CornerRadiiZero()) // 指定头部圆角半径
    .LeeActionSheetCancelActionCornerRadii(CornerRadiiZero()) // 指定取消按钮圆角半径
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
        return CGRectGetWidth([[UIScreen mainScreen] bounds]);
    })
    .LeeActionSheetBackgroundColor([UIColor whiteColor]) // 通过设置背景颜色来填充底部间隙
#ifdef __IPHONE_13_0
    .LeeUserInterfaceStyle(UIUserInterfaceStyleLight)
#endif
    .LeeShow();
}

- (void)setUserInfo:(WFCCUserInfo *)userInfo {
    _userInfo = userInfo;
    self.qrLogo = userInfo.portrait;
    if (userInfo.displayName.length) {
        self.labelStr = userInfo.displayName;
    } else {
        self.labelStr = @"用户";
    }
    self.addressLabel.text = self.userInfo.address;
    self.hintLabel.text = @"扫一扫上面的二维码，加我好友";
    CGSize size = [_nameLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18]}];
    size.width = MIN(size.width, self.qrView.bounds.size.width - 88);
    CGSize adaptionSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    _nameLabel.frame = CGRectMake(95, 28, adaptionSize.width, adaptionSize.height);
    self.maleIcon.frame = CGRectMake(96 + adaptionSize.width, 30, 18, 18);
    /// 如果为男
    if (_userInfo.gender == 1) {
        _maleIcon.image = [UIImage imageNamed:@"contact_Male"];
    } else if (_userInfo.gender == 1) {
        _maleIcon.image = [UIImage imageNamed:@"contact_Female"];
    }
    self.title = @"我的二维码";
    self.addressLabel.text = self.userInfo.address;
}

- (void)setGroupInfo:(WFCCGroupInfo *)groupInfo {
    _groupInfo = groupInfo;
    self.qrLogo = groupInfo.portrait;
    if (groupInfo.name.length) {
        self.labelStr = groupInfo.name;
    } else {
        self.labelStr = @"群聊";
    }
    _nameLabel.frame = CGRectMake(95, 28, self.qrView.bounds.size.width - 100, 22);
    self.hintLabel.text = @"该二维码7天内有效，重新进入将更新";
}

- (void)onUserInfoUpdated:(NSNotification *)notification {
        self.userInfo = notification.userInfo[@"userInfo"];
}

- (void)onGroupInfoUpdated:(NSNotification *)notification {
        self.groupInfo = notification.userInfo[@"groupInfo"];
}

- (void)setQrLogo:(NSString *)qrLogo {
    _qrLogo = qrLogo;
    __weak typeof(self)ws = self;
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        UIImage *logo = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ws.qrLogo]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            ws.logoImgView = [UIImageView new];
            if (logo == nil) {
                ws.logoImgView.image = [UIImage imageNamed:@"PersonalChat"];
            } else {
                ws.logoImgView.image = logo;
            }
            ws.logoImgView.frame = CGRectMake(20, 20, 64, 64);
            ws.logoImgView.layer.masksToBounds = YES;
            ws.logoImgView.layer.cornerRadius = 4;
            [ws.qrView addSubview:ws.logoImgView];
            ws.qrIconImageView.image = ws.logoImgView.image;
        });
    });
}

- (UIImageView *)qrIconImageView {
    if (_qrIconImageView == nil) {
        UIImageView *head = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 60, 60)];
        head.layer.cornerRadius = 6.0;
        _qrIconImageView = head;
        head.layer.masksToBounds = true;
        [self.qrIconView addSubview:head];
    }
    return _qrIconImageView;
}

- (UIImageView *)maleIcon {
    if (_maleIcon == nil) {
        _maleIcon = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 60, 60)];
        [self.qrView addSubview:_maleIcon];
    }
    return _maleIcon;
}

- (UIView *) addressLabel {
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont systemFontOfSize:14];
        _addressLabel.textColor = WFCCUtilities.grayTextColor;
        _addressLabel.frame = CGRectMake(95, 58, self.qrView.bounds.size.width - 72 - 16, 22);
        [self.qrView addSubview:_addressLabel];
    }
    return _addressLabel;
}

- (UIView *) hintLabel {
    if (_hintLabel == nil) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:11];
        _hintLabel.textColor = WFCCUtilities.grayTextColor;
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.frame = CGRectMake(0, 450 - 35, self.qrView.bounds.size.width, 22);
        [self.qrView addSubview:_hintLabel];
    }
    return _hintLabel;
}

- (UIView *) qrIconView {
    if (_qrIconView == nil) {
        CGFloat cornerRadius = 6.0;
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 68, 68)];
        bg.center = CGPointMake(140, 140);
        bg.backgroundColor = [UIColor whiteColor];
        bg.layer.masksToBounds = true;
        bg.layer.cornerRadius = cornerRadius;
        [self.qrImgView addSubview:bg];
        _qrIconView = bg;
    }
    return _qrIconView;
}

- (void)setLabelStr:(NSString *)labelStr {
    _labelStr = labelStr;
    self.nameLabel.text = labelStr;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.qrView addSubview:_nameLabel];
    }
    return _nameLabel;
}


- (UIView *)qrView {
    if (!_qrView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(18, 64, 674/2, 450)];
        [self.view addSubview:view];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5.0;
        view.center = CGPointMake(self.view.frame.size.width/2, 64 + 450/2.0);
        _qrView = view;
    }
    return _qrView;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)createQR_logo
{
    _qrView.hidden = NO;
    _qrImgView.image = [LBXScanNative createQRWithString:self.qrStr QRSize:_qrImgView.bounds.size];
    [_qrImgView bringSubviewToFront:self.qrIconView];
}

- (UIImageView*)roundCornerWithImage:(UIImage*)logoImg size:(CGSize)size
{
    //logo圆角
    UIImageView *backImage = [[UIImageView alloc] initWithCornerRadiusAdvance:6.0f rectCornerType:UIRectCornerAllCorners];
    backImage.frame = CGRectMake(0, 0, size.width, size.height);
    backImage.backgroundColor = [UIColor whiteColor];
    
    UIImageView *logImage = [[UIImageView alloc] initWithCornerRadiusAdvance:6.0f rectCornerType:UIRectCornerAllCorners];
    logImage.image =logoImg;
    CGFloat diff  =2;
    logImage.frame = CGRectMake(diff, diff, size.width - 2 * diff, size.height - 2 * diff);
    
    [backImage addSubview:logImage];
    
    return backImage;
}

- (void)showError:(NSString*)str
{
    [LBXAlertAction showAlertWithTitle:@"提示" msg:str buttonsStatement:@[@"知道了"] chooseBlock:nil];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
