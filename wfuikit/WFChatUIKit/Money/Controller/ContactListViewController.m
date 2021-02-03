//
//  ContactListViewController.m
//  WFChatUIKit
//
//  Created by shangguan on 2019/11/26.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "ContactListViewController.h"

@interface ContactListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ContactListViewController

- (instancetype)init {
    if (self = [super init]) {
        self.selects = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}

- (void)initAll {
    self.dataArray = [NSMutableArray arrayWithCapacity:5];
    [self initUI];
    [self initData];
}

- (void) initData {
    NSArray *numbers = [[WFCCIMService sharedWFCIMService] getGroupMembers:self.agroupId forceUpdate:YES];
    for (WFCCGroupMember *number in numbers) {
        WFCCUserInfo *info = [[WFCCIMService sharedWFCIMService] getUserInfo:number.memberId refresh:YES];
        if ([self.selects containsObject:info.userId]) {
            info.extra = @"1";
        } else {
            info.extra = @"0";
        }
        [self.dataArray addObject:info];
    }
    [self.tableview reloadData];
}

- (void)makeSure {
    if (self.selects.count == 0) {
        [ToastManager showToast:@"请选择指定人" inView:self.view];
    }
    [self.cv updateSelects:self.selects];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateBtn {
    NSString *sureTitle = @"确定";
    if (self.selects.count > 0) {
        sureTitle = [NSString stringWithFormat:@"确定(%ld)",self.selects.count];
    }
    [self.sureBtn setTitle:sureTitle forState:UIControlStateNormal];
    if (self.selects.count == 0) {
        self.sureBtn.enabled = NO;
        self.sureBtn.alpha = 0.4;
    } else {
        self.sureBtn.enabled = YES;
        self.sureBtn.alpha = 1;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell tapSelect];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactListCell"];
    __weak typeof(self) weakSelf = self;
    cell.select = ^(NSString * _Nonnull userId) {
        [weakSelf.selects addObject:userId];
        [weakSelf updateBtn];
    };
    cell.deSelect = ^(NSString * _Nonnull userId) {
        [weakSelf.selects removeObject:userId];
        [weakSelf updateBtn];
    };
    cell.userInfo = self.dataArray[indexPath.row];
    return cell;
}


- (void)initUI {
    self.bar = [[PresentNavigationBar alloc] init];
    [self.bar.backBtn addTarget:self action:@selector(backCLick) forControlEvents:UIControlEventTouchUpInside];
    [self.bar setLeftTitle];
    [self.bar.backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.bar.lineView setHidden:YES];
    [self.view addSubview:self.bar];
    self.view.backgroundColor = self.bar.backgroundColor;
    
    self.sureBtn = [[UIButton alloc] init];
    self.sureBtn.backgroundColor = [UIColor colorWithRed:29/255.0 green:214/255.0 blue:87/255.0 alpha:1.f];
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 4.0;
    self.sureBtn.frame = CGRectMake(gScreenWidth - 90, self.bar.backBtn.frame.origin.y + 6, 70, 32);
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sureBtn addTarget:self action:@selector(makeSure) forControlEvents:UIControlEventTouchUpInside];
    [self.bar.contentView addSubview:self.sureBtn];
    [self.view addSubview:self.tableview];
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bar.frame), gScreenWidth, gScreenHeight - gSafeAreaInsets.bottom - self.bar.frame.size.height)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = 50;
        _tableview.separatorStyle = UITableViewCellSelectionStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"ContactListCell" bundle:[NSBundle bundleForClass:[self class]]] forCellReuseIdentifier:@"ContactListCell"];
    }
    return _tableview;
}

@end
