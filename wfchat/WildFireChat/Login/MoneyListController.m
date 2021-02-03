//
//  MoneyListController.m
//  WildFireChat
//
//  Created by xxx on 2018/12/13.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "MoneyListController.h"
#import "BindCardViewController.h"
#import "MBProgressHUD.h"
#import "ListMoneyCell.h"

@interface MoneyListController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray <XXMoneyRecordModel*>* data;
@end

@implementation MoneyListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [NSMutableArray arrayWithCapacity:0];
    [self initUI];
    [self loadData];
}


- (void)loadData{
    
    [ToastManager showText:@"" inView:self.view];
    NSString *sn = [WFCCNetworkService sharedInstance].userId;
    NSDictionary *param = @{@"userId": sn, @"type": self.type};
    [[NetworkAPI sharedInstance] v2GetWithUrl:APP_jifenHistory params:param successComplection:^(NSDictionary * _Nonnull done) {
        NSArray *value = done[@"data"];
        [self.data removeAllObjects];
        for (NSDictionary *dic in value) {
            XXMoneyRecordModel *model = [XXMoneyRecordModel mj_objectWithKeyValues:dic];
            [self.data addObject:model];
        }
        [self.table reloadData];
        if (self.data.count <= 0) {
            [MBProgressHUD showHUDText:@"NO Record" addedTo:self.view];
        }
    } failureComplection:^(NSDictionary * _Nonnull done) {
        [ToastManager showToast:done[@"msg"] inView:self.view];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListMoneyCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"ListMoneyCell"];
    if (indexPath.row < self.data.count) {
        cell.record = self.data[indexPath.row];
    }
    return cell;
}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.rowHeight = 74;
        _table.backgroundColor = [UIColor whiteColor];
        [_table registerNib:[UINib nibWithNibName:@"ListMoneyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ListMoneyCell"];
        [self.view addSubview:_table];
    }
    return _table;
}

@end
