//
//  SearchResultTableViewController.m
//  WildFireChat
//
//  Created by xxx on 2018/12/15.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "SearchResultTableViewController.h"
#import "BindCardViewController.h"
#import "ShowModel.h"
#import "BetsTableViewCell.h"

static CGFloat headerHeight = 230;
static CGFloat cellHeight = 190;

@interface SearchResultTableHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *zhuang1;
@property (weak, nonatomic) IBOutlet UILabel *l1;
@property (weak, nonatomic) IBOutlet UILabel *l2;

@property (weak, nonatomic) IBOutlet UILabel *l3;
@property (weak, nonatomic) IBOutlet UILabel *l4;
@property (weak, nonatomic) IBOutlet UILabel *l5;
@property (weak, nonatomic) IBOutlet UILabel *l6;
@property (weak, nonatomic) IBOutlet UILabel *l7;
@property (weak, nonatomic) IBOutlet UILabel *v7;

@property (weak, nonatomic) IBOutlet UILabel *boundsl;
@end

@implementation SearchResultTableHeaderView

-(void)awakeFromNib {
    [super awakeFromNib];
    _zhuang1.text = LocalizedString(@"bankerName");
    _l1.text =  LocalizedString(@"created_time");
    _l2.text =  LocalizedString(@"groupId");
    _l3.text =  LocalizedString(@"bonusId");
    _l4.text =  LocalizedString(@"banker");
    _l5.text =  LocalizedString(@"gameId");
    _l6.text =  LocalizedString(@"bankerBonus");
    _l7.text =  LocalizedString(@"zhuangwinlose");
    self.backgroundColor = UIColor.whiteColor;
}

- (void)setModel:(ShowModel *)model {
    _zhuang.text = model.banker;
    _timeLabel.text = model.game.created_time;
    _groupIdLabel.text = model.game.groupId;
    _boundsLabel.text = model.game.bonusId;
    _bankerLabel.text = model.game.banker;
    _statusLabel.text = [NSString stringWithFormat:@"%ld",model.bets.firstObject.gameId];
    _boundsl.text = model.game.bstr;
    _v7.text = model.game.bankerWinStr;
}

@end


@interface SearchResultTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SearchResultTableViewController

+ (void)showResultWithStr:(NSString *)game complection:(ControllervcBlock)block {
    [[NetworkAPI sharedInstance] v2GetWithUrl:@"/app/game" params:@{@"id":game} successComplection:^(NSDictionary * _Nonnull done) {
        if (block) {
            SearchResultTableViewController *search = [SearchResultTableViewController new];
            search.model = [ShowModel mj_objectWithKeyValues:done[@"data"]];
            block(search);
        }
    } failureComplection:^(NSDictionary * _Nonnull done) {
        
    }];
}

- (UITableView *)tableView {
    if (!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = cellHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"BetsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BetsTableViewCell"];
    SearchResultTableHeaderView *header = [NSBundle.mainBundle loadNibNamed:@"ResultHeaderView" owner:nil options:nil].firstObject;
    header.backgroundColor = UIColor.whiteColor;
    header.frame = CGRectMake(0, 0, self.view.frame.size.width, headerHeight);
    [header setModel:self.model];
    self.tableView.tableHeaderView = header;
    [self.tableView reloadData];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.bets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BetsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BetsTableViewCell" forIndexPath:indexPath];
    BetsModel *model = self.model.bets[indexPath.row];
    cell.model = model;
    return cell;
}

@end
