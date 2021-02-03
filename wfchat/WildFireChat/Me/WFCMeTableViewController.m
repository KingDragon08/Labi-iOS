//
//  MeTableViewController.m
//  WFChat UIKit
//
//  Created by WF Chat on 2017/11/4.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#import "WFCMeTableViewController.h"
#import <WFChatClient/WFCChatClient.h>
#import "SDWebImage.h"
#import <WFChatUIKit/WFChatUIKit.h>
#import "WFCSettingTableViewController.h"
#import "WFCSecurityTableViewController.h"
#import "WFCMeTableViewCell.h"
#import "WFCInfoTableViewCell.h"
#import "WFUserModel.h"
#import "TXViewController.h"
#import "BonusViewController.h"
#import "BindCardViewController.h"
#import "ModelSingleLeton.h"

@interface WFCMeTableViewController () <UITableViewDataSource, UITableViewDelegate, UserInfoHeadProtocol> {
    UILabel *_phoneLabel;
    UILabel *_emailLabel;
    WFUserModel *_userModel;
    UITableViewCell *_codeCell;
    UILabel *_jifenLabel;
    UILabel *_redBagLabel;
    UILabel *_inviterLabel;
    UILabel *_invCodeLabel;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIImageView *portraitView;

@property (nonatomic, strong) NSArray <UIImage *> *icons;

@end

@implementation WFCMeTableViewController

- (NSArray<UIImage *> *)icons {
    if (!_icons) {
        NSMutableArray *a = [NSMutableArray arrayWithCapacity:4];
        NSArray *names = @[@"tabbar_chat",@"tabbar_chat",@"tabbar_chat",@"tabbar_chat"];
        for (NSString *name in names) {
            UIImage *ima = [UIImage imageNamed:name];
            [a addObject:ima];
        }
        _icons = [NSArray arrayWithArray:a];
    }
    return _icons;
}
#pragma zhuanzhangxiangguan
- (void)zhuanyue {
    if ([self needBindCard]) {
        [self bindCard:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                BonusViewController *vc = [BonusViewController new];
                vc.type = KJiFen;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            });
        }];
        return;
    }
    BonusViewController *vc = [BonusViewController new];
    vc.type = KJiFen;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)chongzhi {
    if ([self needBindCard]) {
        [self bindCard:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                TXViewController *vc = [TXViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            });
        }];
        return;
    }
    TXViewController *vc = [TXViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tixian {
    if ([self needBindCard]) {
        [self bindCard:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                BonusViewController *vc = [BonusViewController new];
                vc.type = KTiXian;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            });
        }];
        return;
    }
    BonusViewController *vc = [BonusViewController new];
    vc.type = KTiXian;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refresh {
    [self loadDataFromServer];
    [self.tableView reloadData];
}

- (BOOL)needBindCard {
    if (_userModel.bank && _userModel.bank.length > 0) {
        return NO;
    }
    return YES;
}

- (void)bindCard:(BindBlock) block {
    BindCardViewController *vc = [BindCardViewController new];
    vc.block = block;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.image = [UIImage imageNamed:@"beiying"];
    [self.view addSubview:bg];
    UIView *t = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labi_me"]];
    self.navigationItem.titleView = t;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0.1)];
    self.tableView.tableHeaderView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    [self.tableView reloadData];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 200, 0);
    
    [self.view addSubview:self.tableView];
    
    __weak typeof(self)ws = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:kUserInfoUpdated object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if ([[WFCCNetworkService sharedInstance].userId isEqualToString:note.object]) {
            [ws.tableView reloadData];
        }
    }];
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"WFCInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WFCInfoTableViewCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:kChangeLanguageNofiName object:nil];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)loadDataFromServer {
    NSString *sn = [WFCCNetworkService sharedInstance].userId;
    [[NetworkAPI sharedInstance] v2GetWithUrl:APP_USERINFO_V2 params:@{@"sn": sn} successComplection:^(NSDictionary * _Nonnull done) {
        self->_userModel = [WFUserModel mj_objectWithKeyValues:done[@"data"]];
        [self reloadInfos];
    } failureComplection:^(NSDictionary * _Nonnull done) {
        
    }];
    
    [[UserInfo sharedInstance] updateWallet:^(NSDictionary *done) {
        self->_redBagLabel.text = [[UserInfo sharedInstance] getMoneyStr];
    }];
}

- (void)reloadInfos {
    CardModel *carModel = [CardModel new];
    carModel.bank = _userModel.bankName;
    carModel.name = _userModel.realName;
    carModel.number = _userModel.bank;
    [ModelSingleLeton share].cModel = carModel;
    _inviterLabel.text = _userModel.agent;
    _redBagLabel.text = [[UserInfo sharedInstance] getMoneyStr];
    _jifenLabel.text = _userModel.jifen ? _userModel.jifen : @"__";
    _invCodeLabel.text = _userModel.shareCode;
}

- (void)changeLanguage {
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 1;
//    } else if (section == 1) {
//        return 4;
//    } else if (section == 2) {
//        return 1;
//    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFCCUserInfo *me = [[WFCCIMService sharedWFCIMService] getUserInfo:[WFCCNetworkService sharedInstance].userId refresh:YES];
    if(indexPath.section == 0) {
        WFCMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell"];
        if (cell == nil) {
            cell = [[WFCMeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"profileCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            __weak typeof(self) weakSelf = self;
            [cell setBlock:^(NSInteger type) {
                if (type == 0) {
                    WFCUMyPortraitViewController *pvc = [[WFCUMyPortraitViewController alloc] init];
                    pvc.userId = [WFCCNetworkService sharedInstance].userId;
                    [weakSelf.navigationController pushViewController:pvc animated:YES];
                } else if (type == 1) {
                    WFCUModifyMyProfileViewController *mpvc = [[WFCUModifyMyProfileViewController alloc] init];
                    mpvc.modifyType = Modify_DisplayName;
                    mpvc.hidesBottomBarWhenPushed = YES;
                    mpvc.onModified = ^(NSInteger modifyType, NSString *value) {
                        if (modifyType == Modify_DisplayName) {
                            [cell resetDisplayName:value];
                        }
                    };
                    [self.navigationController pushViewController:mpvc animated:YES];
                }
            }];
        }
        cell.backgroundColor = UIColor.clearColor;
        cell.userInfo = me;
        _jifenLabel = cell.jifen;
        _redBagLabel = cell.hongbao;
        cell.hongbao.text = [[UserInfo sharedInstance] getMoneyStr];
        [cell changeLanguage];
        return cell;
    } else {
        WFCInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WFCInfoTableViewCell"];
        NSInteger section = indexPath.section - 1;
        switch (section) {
            case 0:
                cell.tLabel.text = LocalizedString(@"LoginID");
                cell.vLabel.text = me.name;
                cell.icon.image = [UIImage imageNamed:@"labi_icon_2"];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.line.hidden = NO;
                break;
            case 1:
                cell.tLabel.text = LocalizedString(@"Introducer");
                cell.vLabel.text = _userModel.agent;
                _inviterLabel = cell.vLabel;
                cell.icon.image = [UIImage imageNamed:@"labi_icon_5"];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.line.hidden = NO;
                break;
            case 2:
                cell.tLabel.text = LocalizedString(@"PhoneNum");
                cell.icon.image = [UIImage imageNamed:@"labi_icon_6"];
                cell.vLabel.text = me.mobile;
                _phoneLabel = cell.vLabel;
                cell.line.hidden = NO;
                break;
            case 3:
                cell.tLabel.text = LocalizedString(@"Email");
                cell.icon.image = [UIImage imageNamed:@"labi_icon_7"];
                cell.vLabel.text = me.email;
                _emailLabel = cell.vLabel;
                cell.line.hidden = NO;
                break;
            case 4:
                cell.tLabel.text = LocalizedString(@"InvitationCode");
                cell.vLabel.text = me.email;
                _invCodeLabel = cell.vLabel;
                cell.icon.image = [UIImage imageNamed:@"labi_icon_5"];
                cell.line.hidden = YES;
                break;
            default:
                break;
        }
        cell.backgroundColor = UIColor.clearColor;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [WFCMeTableViewCell cellHeight] + 20;
    } else {
        return 70;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.1, 0.1)];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.1, 0.1)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
    } else if (indexPath.section == 3 || indexPath.section == 4) {
        
        WFCUModifyMyProfileViewController *mpvc = [[WFCUModifyMyProfileViewController alloc] init];
        mpvc.modifyType = indexPath.section;
        mpvc.hidesBottomBarWhenPushed = YES;
        __weak typeof(self)ws = self;
        mpvc.onModified = ^(NSInteger modifyType, NSString *value) {
            __strong typeof(ws) ss = ws;
            if (indexPath.row == 3) {
                ss->_phoneLabel.text = value;
            } else if (indexPath.row == 4) {
                ss->_emailLabel.text = value;
            }
        };
        [self.navigationController pushViewController:mpvc animated:YES];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
