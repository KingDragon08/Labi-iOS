//
//  SettingTableViewController.m
//  WFChat UIKit
//
//  Created by WF Chat on 2017/10/6.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#import "WFCSecurityTableViewController.h"
#import <WFChatClient/WFCChatClient.h>
#import <WFChatUIKit/WFChatUIKit.h>

@interface WFCSecurityTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) WalletStatus status;

@end

@implementation WFCSecurityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:236/255.0 green:237/255.0 blue:238/255.0 alpha:1];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView reloadData];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUserInfo];
}

- (void)updateUserInfo {
    self.status = WALLET_OTHERCODE;
    __weak typeof(self) weakself = self;
    [[UserInfo sharedInstance] updateWallet:^(NSDictionary *done) {
        BOOL isTrue = [done[@"hasWallet"] integerValue];
        if (isTrue) {
            weakself.status = [done[@"status"] integerValue];
        } else {
            weakself.status = [done[@"status"] integerValue];
        }
        [weakself.tableView reloadData];
    }];
}

- (void)recharge {
    return;
//    __weak typeof(self) weakself = self;
//    NSDictionary *param = @{@"userId":[UserInfo sharedInstance].userId, @"money":@"1000",@"scores":@"0",@"payNumber":@"111111"};
//
//    [ToastManager showText:@"" inView:self.view];
//    [[NetworkAPI sharedInstance] postWithUrl:WALLET_RECHARGE params:param successComplection:^(NSDictionary * _Nonnull done) {
//        [ToastManager showToast:@"Success" inView:self.view];
//    } failureComplection:^(NSDictionary * _Nonnull done) {
//        [ToastManager showToast:done[@"msg"] inView:self.view];
//    }];
//
//    [[UserInfo sharedInstance] updateWallet:^(NSDictionary *done) {
//        BOOL isTrue = [done[@"hasWallet"] integerValue];
//        if (isTrue) {
//            weakself.status = [done[@"status"] integerValue];
//        } else {
//            weakself.status = [done[@"status"] integerValue];
//        }
//        [weakself.tableView reloadData];
//    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
    } else if (indexPath.row == 1) {
        if (self.status == CREATE_WALLET) {
            PasswordSettingViewController *p = [[PasswordSettingViewController alloc] init];
            p.userId = [[WFCCNetworkService sharedInstance] userId];
            [self.navigationController pushViewController:p animated:YES];
        }
    } else if (indexPath.row == 2) {
        [self recharge];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

//#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.status == HAS_WALLET ) {
            return 3;
        } else if (self.status == CREATE_WALLET) {
            return 3;
        }
        return 1;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"style1Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"style1Cell"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = LocalizedString(@"ChangePassword");
    } else if (indexPath.row == 1) {
        if (self.status == CREATE_WALLET) {
            cell.textLabel.text = LocalizedString(@"CreateWallet");
        } else if (self.status == HAS_WALLET) {
            cell.textLabel.text = LocalizedString(@"WalletBalance");
            cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@元",[[UserInfo sharedInstance] getMoneyStr]];
        }
    } else if (indexPath.row == 2) {
        cell.textLabel.text = LocalizedString(@"Recharge");
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
