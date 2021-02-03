//
//  WFCUProfileTableViewController.m
//  WFChat UIKit
//
//  Created by WF Chat on 2017/10/22.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#import "WFCUProfileTableViewController.h"
#import "SDWebImage.h"
#import <WFChatClient/WFCChatClient.h>
#import "WFCUMessageListViewController.h"
#import "MBProgressHUD.h"
#import "WFCUMyPortraitViewController.h"
#import "WFCUVerifyRequestViewController.h"
#import "WFCUGeneralModifyViewController.h"
#import "WFCUVideoViewController.h"
#import "LEEAlert.h"
#if WFCU_SUPPORT_VOIP
#import <WFAVEngineKit/WFAVEngineKit.h>
#endif

@interface WFCUProfileTableViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
@property (strong, nonatomic)UIImageView *portraitView;
@property (strong, nonatomic)UILabel *aliasLabel;
@property (strong, nonatomic)UILabel *displayNameLabel;
@property (strong, nonatomic)UITableViewCell *headerCell;


@property (strong, nonatomic)UILabel *mobileLabel;
@property (strong, nonatomic)UILabel *emailLabel;
@property (strong, nonatomic)UILabel *addressLabel;
@property (strong, nonatomic)UILabel *companyLabel;
@property (strong, nonatomic)UILabel *socialLabel;

@property (strong, nonatomic)UITableViewCell *sendMessageCell;
@property (strong, nonatomic)UITableViewCell *voipCallCell;
@property (strong, nonatomic)UITableViewCell *addFriendCell;
@property (strong, nonatomic)UITableViewCell *timeLineCell;
@property (strong, nonatomic)UIView *timeLineView;

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray<UITableViewCell *> *cells;

@property (nonatomic, strong)WFCCUserInfo *userInfo;
@end

@implementation WFCUProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self)ws = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:kUserInfoUpdated object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if ([ws.userId isEqualToString:note.object]) {
            WFCCUserInfo *userInfo = note.userInfo[@"userInfo"];
            ws.userInfo = userInfo;
            [ws loadData];
            NSLog(@"reload user info %@", ws.userInfo.userId);
        }
    }];
    self.title = @"用户信息";
    self.userInfo = [[WFCCIMService sharedWFCIMService] getUserInfo:self.userId refresh:YES];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = WFCCUtilities.backgoundColor;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.10)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.10)];
    
    if([[WFCCNetworkService sharedInstance].userId isEqualToString:self.userId] == NO) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"action_more"] style:UIBarButtonItemStyleDone target:self action:@selector(onRightBtn:)];
    }
    [self loadData];
}

- (void)onRightBtn:(id)sender {
    NSString *title;
    UIActionSheet *actionSheet;
    if ([[WFCCIMService sharedWFCIMService] isMyFriend:self.userId]) {
        title = WFCString(@"DeleteFriend");
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:WFCString(@"Cancel") destructiveButtonTitle:title otherButtonTitles:WFCString(@"SetAlias"), nil];
    } else {
        title = WFCString(@"AddFriend");
        if ([[WFCCIMService sharedWFCIMService] isBlackListed:self.userId]) {
            title = WFCString(@"RemoveFromBlacklist");
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:WFCString(@"Cancel") destructiveButtonTitle:title otherButtonTitles:nil];
        } else {
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:WFCString(@"Cancel") destructiveButtonTitle:title otherButtonTitles:WFCString(@"Add2Blacklist"), nil];
        }
    }
    
    [actionSheet showInView:self.view];
}
- (void)loadData {
    self.cells = [[NSMutableArray alloc] init];
    
    self.headerCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    for (UIView *subView in self.headerCell.subviews) {
        [subView removeFromSuperview];
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    self.portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 68, 68)];
    self.headerCell.backgroundColor = [UIColor whiteColor];
    self.portraitView.layer.masksToBounds = YES;
    self.portraitView.layer.cornerRadius = 4.0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewPortrait:)];
    [self.portraitView addGestureRecognizer:tap];
    self.portraitView.userInteractionEnabled = YES;
    
    
    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:[self.userInfo.portrait stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage: [UIImage imageNamed:@"PersonalChat"]];
    
    NSString *alias = [[WFCCIMService sharedWFCIMService] getFriendAlias:self.userId];
    
    if (alias.length) {
        self.aliasLabel = [[UILabel alloc] initWithFrame:CGRectMake(88, 8, width - 64 - 8, 21)];
        self.aliasLabel.text = alias;
        self.aliasLabel.font = [UIFont boldSystemFontOfSize:22];
        self.displayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(88, 30, width - 64 - 8, 21)];
        self.displayNameLabel.text = [NSString stringWithFormat:@"昵称：%@",self.userInfo.displayName];
        self.displayNameLabel.font = [UIFont systemFontOfSize:15];
        self.mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(88, 54, width - 64 - 8, 20)];
        self.mobileLabel.font = self.displayNameLabel.font;
        self.mobileLabel.textColor = HEXCOLOR(0x7E7F80);
        self.displayNameLabel.textColor = HEXCOLOR(0x7E7F80);
    } else {
        self.aliasLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.displayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(88, 10, width - 64 - 8, 21)];
        self.displayNameLabel.font = [UIFont boldSystemFontOfSize:22];
        self.displayNameLabel.text = self.userInfo.displayName;
        
        self.mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(88, 42, width - 64 - 8, 20)];
        self.mobileLabel.font = [UIFont systemFontOfSize:15];
        self.mobileLabel.textColor = HEXCOLOR(0x7E7F80);
    }
    self.mobileLabel.text = [NSString stringWithFormat:@"账号：%@",self.userInfo.userId];
    [self.headerCell.contentView addSubview:self.portraitView];
    [self.headerCell.contentView addSubview:self.displayNameLabel];
    [self.headerCell.contentView addSubview:self.aliasLabel];
    [self.headerCell.contentView addSubview:self.mobileLabel];
    self.headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    if ([[WFCCIMService sharedWFCIMService] isMyFriend:self.userId]) {
//        if (self.userInfo.mobile.length > 0) {
//            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//            cell.textLabel.text = self.userInfo.mobile;
//            [self.cells addObject:cell];
//        }
//
//        if (self.userInfo.email.length > 0) {
//            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//            cell.textLabel.text = self.userInfo.email;
//            [self.cells addObject:cell];
//        }
//
//        if (self.userInfo.address.length) {
//            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//            cell.textLabel.text = self.userInfo.address;
//            [self.cells addObject:cell];
//        }
//
//        if (self.userInfo.company.length) {
//            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//            cell.textLabel.text = self.userInfo.company;
//            [self.cells addObject:cell];
//        }
//
//        if (self.userInfo.social.length) {
//            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//            cell.textLabel.text = self.userInfo.social;
//            [self.cells addObject:cell];
//        }
//    }
    /// 好友关系
    if ([[WFCCIMService sharedWFCIMService] isMyFriend:self.userId]) {
        self.sendMessageCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        for (UIView *subView in self.sendMessageCell.subviews) {
            [subView removeFromSuperview];
        }
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 8, width - 40, 40)];
        [btn setTitleColor:[UIColor colorWithRed:88/255.0 green:108/255.0 blue:144/255.0 alpha:1.0] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [btn setImage:[UIImage imageNamed:@"voip_message"] forState:UIControlStateNormal];
        [btn setTitle:WFCString(@"SendMessage") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onSendMessageBtn:) forControlEvents:UIControlEventTouchDown];
        btn.layer.cornerRadius = 5.f;
        btn.layer.masksToBounds = YES;
        [self.sendMessageCell.contentView addSubview:btn];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 55 - WFCCUtilities.onepxLine, width, WFCCUtilities.onepxLine)];
        line.backgroundColor = WFCCUtilities.onePxLineColor;
        [self.sendMessageCell.contentView addSubview:line];

#if WFCU_SUPPORT_VOIP
        self.voipCallCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        for (UIView *subView in self.voipCallCell.subviews) {
            [subView removeFromSuperview];
        }
        
        btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 8, width - 40, 40)];
        [btn setTitleColor:[UIColor colorWithRed:88/255.0 green:108/255.0 blue:144/255.0 alpha:1.0] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [btn setImage:[UIImage imageNamed:@"ChatRoom_Bubble_VOIP_Video"] forState:UIControlStateNormal];
        [btn setTitle:WFCString(@"VOIPCall") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onVoipCallBtn:) forControlEvents:UIControlEventTouchDown];
        btn.layer.cornerRadius = 5.f;
        btn.layer.masksToBounds = YES;
        [self.voipCallCell.contentView addSubview:btn];
#endif
    } else if([[WFCCNetworkService sharedInstance].userId isEqualToString:self.userId]) {
        
    } else {
        self.addFriendCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        for (UIView *subView in self.addFriendCell.subviews) {
            [subView removeFromSuperview];
        }
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 8, width - 40, 40)];
        [btn setTitle:WFCString(@"AddFriend") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onAddFriendBtn:) forControlEvents:UIControlEventTouchDown];
        [btn setTitleColor:[UIColor colorWithRed:88/255.0 green:108/255.0 blue:144/255.0 alpha:1.0] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [self.addFriendCell.contentView addSubview:btn];
        
    }
    
    self.timeLineCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timeLineCell"];
    for (UIView *sub in self.timeLineCell.subviews) {
        [sub removeFromSuperview];
    }
    self.timeLineCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.timeLineCell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 21, 60, 30)];
    timeLabel.text = @"朋友圈";
    timeLabel.font = [UIFont systemFontOfSize:16];
    [self.timeLineCell.contentView addSubview:timeLabel];
    
    self.timeLineView = [[UIView alloc] initWithFrame:CGRectMake(160, 6, width - 190, 60)];
    [self.timeLineCell.contentView addSubview: self.timeLineView];
    [self reloadTimeLine:@[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1572941542256&di=0802295c13923e9f87d2daebe1fa8f46&imgtype=0&src=http%3A%2F%2Fwww.people.com.cn%2Fmediafile%2Fpic%2F20191105%2F41%2F8740810824566334101.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1572941542256&di=0eca5fd7298a49a2724686a36f75843a&imgtype=0&src=http%3A%2F%2Fpic.ruiwen.com%2Fallimg%2F201608%2F62-160q61s1054e.png",@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=509168620,4169146300&fm=26&gp=0.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1572941542255&di=525b3c6e85722b1f718a0649b9a3f4b0&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fq_70%2Cc_zoom%2Cw_640%2Fimages%2F20180814%2F0ab6cb4db93f40d791a8ef07b340ddcc.jpeg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1572941542255&di=0cda000e1bc5b6b2587b5787ae4d2a67&imgtype=0&src=http%3A%2F%2Fpic4.40017.cn%2Fscenery%2Fdestination%2F2016%2F07%2F26%2F16%2FC7dwqP.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1572941542254&di=bbb3f1d2c75eeb4d38d8ff5a101bb325&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F2018-03-20%2F5ab0ac5a751bf.jpg"]];
    [self.tableView reloadData];
}

- (void) reloadTimeLine:(NSArray <NSString *>*) images {
    for (UIView *sub in self.timeLineView.subviews) {
        [sub removeFromSuperview];
    }

    for (int i=0; i< images.count; i++) {
        UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(65*(i-1), 0, 60, 60)];
        [im sd_setImageWithURL:[NSURL URLWithString:images[i]]];
        if (65*(i-1) + 60 < [UIScreen mainScreen].bounds.size.width - 190) {
            [self.timeLineView addSubview:im];
        } else {
            break;
        }
    }
}

- (void)onViewPortrait:(id)sender {
    WFCUMyPortraitViewController *pvc = [[WFCUMyPortraitViewController alloc] init];
    pvc.userId = self.userId;
    [self.navigationController pushViewController:pvc animated:YES];
}


- (void)onSendMessageBtn:(id)sender {
    WFCUMessageListViewController *mvc = [[WFCUMessageListViewController alloc] init];
    mvc.conversation = [WFCCConversation conversationWithType:Single_Type target:self.userId line:0];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[WFCUMessageListViewController class]]) {
            WFCUMessageListViewController *old = (WFCUMessageListViewController*)vc;
            if (old.conversation.type == Single_Type && [old.conversation.target isEqualToString:self.userId]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
    }
    UINavigationController *nav = self.navigationController;
    [self.navigationController popToRootViewControllerAnimated:NO];
    mvc.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:mvc animated:YES];
}

- (void)onVoipCallBtn:(id)sender {
#if WFCU_SUPPORT_VOIP
    __weak typeof(self)ws = self;
     [LEEAlert actionsheet].config.LeeDestructiveAction(@"视频通话", ^{
            // 点击事件回调Block
            WFCCConversation *conversation = [WFCCConversation conversationWithType:Single_Type target:ws.userInfo.userId line:0];
            WFCUVideoViewController *videoVC = [[WFCUVideoViewController alloc] initWithTarget:ws.userInfo.userId conversation:conversation audioOnly:NO];
            [[WFAVEngineKit sharedEngineKit] presentViewController:videoVC];
     }).LeeDestructiveAction(@"语音通话", ^{
         WFCCConversation *conversation = [WFCCConversation conversationWithType:Single_Type target:ws.userInfo.userId line:0];
                WFCUVideoViewController *videoVC = [[WFCUVideoViewController alloc] initWithTarget:ws.userInfo.userId conversation:conversation audioOnly:YES];
                [[WFAVEngineKit sharedEngineKit] presentViewController:videoVC];
     })
        .LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeCancel;
            action.title = @"取消";
            action.titleColor = [UIColor blackColor];
            action.font = [UIFont systemFontOfSize:17.0f];
        })
        .LeeActionSheetCancelActionSpaceColor(WFCCUtilities.backgoundColor) // 设置取消按钮间隔的颜色
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
#endif
}

- (void)onAddFriendBtn:(id)sender {
    WFCUVerifyRequestViewController *vc = [[WFCUVerifyRequestViewController alloc] init];
    vc.userId = self.userId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource<NSObject>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section <= 1) {
        return 1;
    }
    //    } else if(section == 1) {
    //        return self.cells.count;
    //    } else {
    if([[WFCCNetworkService sharedInstance].userId isEqualToString:self.userId]) {
        return 0;
    }
    if (self.sendMessageCell) {
        return 2;
    } else {
        return 1;
    }
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.headerCell;
    }
    if (indexPath.section == 1) {
        return [UITableViewCell new];
//        self.timeLineCell;
    }
        //    } else if (indexPath.section == 1) {
        //        return self.cells[indexPath.row];
        //    } else {
    if (self.sendMessageCell) {
        if (indexPath.row == 0) {
            return self.sendMessageCell;
        } else {
            return self.voipCallCell;
        }
    } else {
        return self.addFriendCell;
    }
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([[WFCCNetworkService sharedInstance].userId isEqualToString:self.userId]) {
        return 2;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 84;
    } else if (indexPath.section == 1) {
        return 0;
    }
    
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == self.timeLineCell) {
        NSLog(@"朋友圈点击跳转");
    }
}


#pragma mark -  UIActionSheetDelegate <NSObject>
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[WFCCIMService sharedWFCIMService] isMyFriend:self.userId]) {
        //0, 删除好友，1 添加备注
        if(buttonIndex == 0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = @"处理中...";
            [hud showAnimated:YES];
            [[WFCCIMService sharedWFCIMService] deleteFriend:self.userId success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = @"处理成功";
                    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                    [hud hideAnimated:YES afterDelay:1.f];
                });
            } error:^(int error_code) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = @"处理失败";
                    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                    [hud hideAnimated:YES afterDelay:1.f];
                });
            }];
        } else if(buttonIndex == 1) {
            WFCUGeneralModifyViewController *gmvc = [[WFCUGeneralModifyViewController alloc] init];
            NSString *previousAlias = [[WFCCIMService sharedWFCIMService] getFriendAlias:self.userId];
            gmvc.defaultValue = previousAlias;
            gmvc.titleText = @"设置备注";
            gmvc.canEmpty = YES;
            __weak typeof(self)ws = self;
            gmvc.tryModify = ^(NSString *newValue, void (^result)(BOOL success)) {
                if (![newValue isEqualToString:previousAlias]) {
                    [[WFCCIMService sharedWFCIMService] setFriend:self.userId alias:newValue success:^{
                        result(YES);
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [ws loadData];
                        });
                    } error:^(int error_code) {
                        result(NO);
                    }];
                }
            };
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:gmvc];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
    } else {
        if ([[WFCCIMService sharedWFCIMService] isBlackListed:self.userId]) {
            //0 取消屏蔽
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = @"处理中...";
            [hud showAnimated:YES];
            if (buttonIndex == 0) {
                [[WFCCIMService sharedWFCIMService] setBlackList:self.userId isBlackListed:NO success:^{
                    [hud hideAnimated:YES];
                    
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = @"处理成功";
                    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                    [hud hideAnimated:YES afterDelay:1.f];
                } error:^(int error_code) {
                    [hud hideAnimated:YES];
                    
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = @"处理失败";
                    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                    [hud hideAnimated:YES afterDelay:1.f];
                }];
            }
        } else {
            //0，添加好友；1 屏蔽用户
            if (buttonIndex == 0) {
                    WFCUVerifyRequestViewController *vc = [[WFCUVerifyRequestViewController alloc] init];
                    vc.userId = self.userId;
                    [self.navigationController pushViewController:vc animated:YES];
            } else if(buttonIndex == 1) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.label.text = @"处理中...";
                [hud showAnimated:YES];
                [[WFCCIMService sharedWFCIMService] setBlackList:self.userId isBlackListed:YES success:^{
                    [hud hideAnimated:YES];
                    
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = @"处理成功";
                    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                    [hud hideAnimated:YES afterDelay:1.f];
                } error:^(int error_code) {
                    [hud hideAnimated:YES];
                    
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = @"处理失败";
                    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                    [hud hideAnimated:YES afterDelay:1.f];
                }];
            }
        }
    }
    
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
