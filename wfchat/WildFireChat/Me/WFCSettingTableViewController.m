//
//  SettingTableViewController.m
//  WFChat UIKit
//
//  Created by WF Chat on 2017/10/6.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#import "WFCSettingTableViewController.h"
#import <WFChatClient/WFCChatClient.h>
#import "SDWebImage.h"
#import <WFChatUIKit/WFChatUIKit.h>
#import "WFCSecurityTableViewController.h"
#import "WFCAboutViewController.h"
#import "WFCPrivacyViewController.h"
#import "WFCPrivacyTableViewController.h"
#import "AlterViewController.h"
#import "CardTableViewController.h"
#import "MoneyListController.h"
#import "BindCardViewController.h"
#import "CardTableViewController.h"
#import "ModelSingleLeton.h"
#import "HistoryViewController.h"

@interface WFCSettingTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation WFCSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.image = [UIImage imageNamed:@"beiying"];
    [self.view addSubview:bg];
    UIView *t = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labi_setting"]];
    self.navigationItem.titleView = t;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0.1)];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0.1)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColor.clearColor;
    [self.tableView reloadData];
//    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beiying"]];
    [self.view addSubview:self.tableView];
    [self loadDataFromServer];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)loadDataFromServer {
    NSString *sn = [WFCCNetworkService sharedInstance].userId;
    [[NetworkAPI sharedInstance] v2GetWithUrl:APP_USERINFO_V2 params:@{@"sn": sn} successComplection:^(NSDictionary * _Nonnull done) {
        WFUserModel *uModel = [WFUserModel mj_objectWithKeyValues:done[@"data"]];
        CardModel *carModel = [CardModel new];
        carModel.bank = uModel.bankName;
        carModel.name = uModel.realName;
        carModel.number = uModel.bank;
        [ModelSingleLeton share].cModel = carModel;
    } failureComplection:^(NSDictionary * _Nonnull done) {
        
    }];
}
- (void)changeLanage {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:LocalizedString(@"ChangeLaunage") preferredStyle:UIAlertControllerStyleActionSheet];
    //初始化一个UIAlertController的警告框将要用到的UIAlertAction style cancle
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:LocalizedString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    //初始化一个UIAlertController的警告框将要用到的UIAlertAction style Default
    UIAlertAction *wx = [UIAlertAction actionWithTitle:@"English" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self reseLanguageFromype:kLanguageTypeEn];
    }];
    //初始化一个UIAlertController的警告框将要用到的UIAlertAction style Default
    UIAlertAction *wb = [UIAlertAction actionWithTitle:@"简体中文" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self reseLanguageFromype:kLanguageTypeZhHans];
    }];
    
    //初始化一个UIAlertController的警告框将要用到的UIAlertAction style Default Malaysia
    UIAlertAction *yuenan = [UIAlertAction actionWithTitle:@"Malaysia" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self reseLanguageFromype:kLanguageVi];
    }];
    //将初始化好的UIAlertAction添加到UIAlertController中
    [alertController addAction:cancle];
    [alertController addAction:wx];
    [alertController addAction:wb];
    [alertController addAction:yuenan];
    //将初始化好的j提示框显示出来
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)reseLanguageFromype:(LanguageType)type {
    if ([[ZBLocalized sharedInstance] setLanguage: type]) {
        [self reSetLanguage];
    }
}

- (void)reSetLanguage {
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeLanguageNofiName object:nil];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (1 == section) {
        return 0.1;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0.1)];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0.1)];
}

- (void)toChat:(NSIndexPath *)indexpath {
    
    HistoryViewController *money = [HistoryViewController new];
    money.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:money animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 修改密码
            AlterViewController *vc = [AlterViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if(indexPath.row == 1) {
            WFCUMessageListViewController *mvc = [[WFCUMessageListViewController alloc] init];
            mvc.conversation = [[WFCCConversation alloc] init];
            mvc.conversation.type = Single_Type;
            mvc.conversation.target = @"cgc8c8VV";
            mvc.conversation.line = 0;
        
            mvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mvc animated:YES];
        } else if(indexPath.row == 2) {
            [self changeLanage];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            HistoryViewController *vc = [HistoryViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            CardTableViewController *vc = [CardTableViewController new];
            vc.bind = YES;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    return;
    
    if (indexPath.section == 0) {
        WFCPrivacyTableViewController *pvc = [[WFCPrivacyTableViewController alloc] init];
        pvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pvc animated:YES];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            WFCUMessageListViewController *mvc = [[WFCUMessageListViewController alloc] init];
            mvc.conversation = [[WFCCConversation alloc] init];
            mvc.conversation.type = Single_Type;
            mvc.conversation.target = @"cgc8c8VV";
            mvc.conversation.line = 0;
        
            mvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mvc animated:YES];
        } else if (indexPath.row == 2) {
            WFCAboutViewController *avc = [[WFCAboutViewController alloc] init];
            [self.navigationController pushViewController:avc animated:YES];
        }
    } else if(indexPath.section == 2) {
        if (indexPath.row == 0) {
            WFCPrivacyViewController * pvc = [[WFCPrivacyViewController alloc] init];
            pvc.isPrivacy = NO;
            [self.navigationController pushViewController:pvc animated:YES];
        } else if(indexPath.row == 1) {
            WFCPrivacyViewController * pvc = [[WFCPrivacyViewController alloc] init];
            pvc.isPrivacy = YES;
            [self.navigationController pushViewController:pvc animated:YES];
        }
    } else if(indexPath.section == 3) {
        __weak typeof(self)ws = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"举报" message:@"如果您发现有违反法律和道德的内容，或者您的合法权益受到侵犯，请截图之后发送给我们。我们会在24小时之内处理。处理办法包括不限于删除内容，对作者进行警告，冻结账号，甚至报警处理。举报请到\"设置->设置->举报\"联系我们！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [alertController addAction:action1];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            WFCUMessageListViewController *mvc = [[WFCUMessageListViewController alloc] init];
            mvc.conversation = [[WFCCConversation alloc] init];
            mvc.conversation.type = Single_Type;
            mvc.conversation.target = @"cgc8c8VV";
            mvc.conversation.line = 0;
            
            mvc.hidesBottomBarWhenPushed = YES;
            [ws.navigationController pushViewController:mvc animated:YES];
        }];
        [alertController addAction:action2];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

//#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return 3;
    } else if (section == 2) {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"style1Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"style1Cell"];
    }
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = LocalizedString(@"ChangePassword");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 55 - WFCCUtilities.onepxLine, self.view.frame.size.width - 20, WFCCUtilities.onepxLine)];
            line.backgroundColor = WFCCUtilities.onePxLineColor;
            [cell.contentView addSubview:line];
        } else if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = LocalizedString(@"HelpFeedback");
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 55 - WFCCUtilities.onepxLine, self.view.frame.size.width - 20, WFCCUtilities.onepxLine)];
            line.backgroundColor = WFCCUtilities.onePxLineColor;
            [cell.contentView addSubview:line];
        }else if (indexPath.row == 2) {
            cell.textLabel.text = LocalizedString(@"Language");
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 55 - WFCCUtilities.onepxLine, self.view.frame.size.width - 20, WFCCUtilities.onepxLine)];
            line.backgroundColor = WFCCUtilities.onePxLineColor;
            cell.detailTextLabel.text = [[ZBLocalized sharedInstance] currentLanguageDesc];
            [cell.contentView addSubview:line];
//            LocalizedString(@"AboutWFChat");
        } else if (indexPath.row == 3) {
            cell.textLabel.text = LocalizedString(@"QuietMode");
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 55 - WFCCUtilities.onepxLine, self.view.frame.size.width - 20, WFCCUtilities.onepxLine)];
            line.backgroundColor = WFCCUtilities.onePxLineColor;
            CGFloat w = self.view.frame.size.width;
            UISwitch *s = [[UISwitch alloc] initWithFrame:CGRectMake(w - 60, 10, 80, 35)];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kSlientState"]) {
                s.on = YES;
            }
            [cell.contentView addSubview:s];
            [s addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:line];
        }
        cell.detailTextLabel.textColor = WFCCUtilities.onePxLineColor;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = LocalizedString(@"MoneyRecords");
        } else if (indexPath.row == 1) {
            cell.textLabel.text = LocalizedString(@"BindCard");
        } else if (indexPath.row == 2) {
            cell.textLabel.text = LocalizedString(@"CurrentVersion");
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(%@)",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 55 - WFCCUtilities.onepxLine, self.view.frame.size.width - 20, WFCCUtilities.onepxLine)];
            line.backgroundColor = WFCCUtilities.onePxLineColor;
            [cell.contentView addSubview:line];
            cell.detailTextLabel.textColor = WFCCUtilities.onePxLineColor;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 55 - WFCCUtilities.onepxLine, self.view.frame.size.width - 20, WFCCUtilities.onepxLine)];
        line.backgroundColor = WFCCUtilities.onePxLineColor;
        [cell.contentView addSubview:line];
        
    } else if (indexPath.section == 2) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"buttonCell"];
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, self.view.frame.size.width - 140, 50)];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 25;
        [btn setBackgroundImage:[UIImage imageNamed:@"labi_btn_bg_hl"] forState:UIControlStateNormal];
        [btn setTitle:LocalizedString(@"Logout") forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];

        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onLogoutBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
    cell.backgroundColor = UIColor.clearColor;
    cell.textLabel.textColor = UIColor.whiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)changeState:(UISwitch *)sender {
    UserInfo.sharedInstance.slient = sender.on;
}
 
- (void)onLogoutBtn:(id)sender {
    [LEEAlert actionsheet].config
    .LeeContent(LocalizedString(@"LogOutWarning"))
    .LeeDestructiveAction(LocalizedString(@"Logout"), ^{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedName"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedToken"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedUserId"];
        [[WFCCNetworkService sharedInstance] disconnect:YES];
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        
        action.title = LocalizedString(@"Cancel");
        
        action.titleColor = [UIColor blackColor];
        
        action.font = [UIFont systemFontOfSize:18.0f];
    })
    .LeeActionSheetCancelActionSpaceColor([WFCUConfigManager globalManager].backgroudColor)// 设置取消按钮间隔的颜色
    .LeeActionSheetCancelActionSpaceWidth(5)
    .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
    .LeeCornerRadii(CornerRadiiMake(10, 10, 0, 0))   // 指定整体圆角半径
    .LeeActionSheetHeaderCornerRadii(CornerRadiiMake(10, 10, 0, 0)) // 指定头部圆角半径
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
@end
