//
//  LuckyMoneyDetailViewController.m
//  WFChatUIKit
//
//  Created by xxx on 2019/11/20.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "LuckyMoneyDetailViewController.h"
#import "HasInRobedResultList.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "AgroupLuckyMoneyAccept.h"
#import "SingleLuckyMoneyAxcepted.h"

@interface LuckyMoneyDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray <MoneyRecordModel*>* data;
@property (nonatomic, strong) UIImageView *scrollImage;
@property (nonatomic, strong) CAShapeLayer *shaperLayer;
@property (nonatomic, strong) HasInRobedResultList *header;
@property (nonatomic, strong) NSMutableArray <NSURLSessionDataTask *>*tasks;

@end

@implementation LuckyMoneyDetailViewController {
    BOOL _inList;
    CGFloat _layerHeight;
    CGFloat _headerHeight;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tasks = [NSMutableArray arrayWithCapacity:3];
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = 200;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveMessages:) name:kReceiveMessages object:nil];
    [self initUI];
    [self loadData];
}

- (void)onReceiveMessages:(NSNotification *)notification {
    NSArray<WFCCMessage *> *messages = notification.object;
    for (WFCCMessage *message in messages) {
        if ([message.conversation.target isEqualToString:self.conversationId] && ([message.content isKindOfClass:[AgroupLuckyMoneyAcceptMessageContent class]] || [message.content isKindOfClass:[LuckyMoneyAcceptMessageContent class]])) {
            if (self.tasks.count > 0) {
                for (NSURLSessionDataTask *task in self.tasks) {
                    [task cancel];
                }
            } else {
                self.allRecord = nil;
                [self loadData];
            }
        }
    }
}


- (void)loadData{
    if (self.allRecord != nil) {
        if (self.allRecord.mineRecord) {
            _inList = YES;
        }
        self.data = [NSMutableArray arrayWithArray:self.allRecord.records];
        [self addHeadView];
        [self.header setModel:self.allRecord];
        [self setHeaderImage];
        [self.table reloadData];
        return;
    }
    
    if (!self.redPId) {
        [ToastManager showToast:@"REDPID 为空" inView:self.view];
        return;
    }
    
    [ToastManager showText:@"" inView:self.view];
    [[NetworkAPI sharedInstance] getWithUrl:MONEY_LUCKYMONEY_DETAILS params:@{@"redPId":self.redPId} successComplection:^(NSDictionary * _Nonnull done) {
        LuckyMoneyListModel *model = [LuckyMoneyListModel mj_objectWithKeyValues:done[@"data"]];
        self.allRecord = model;
        if (model.mineRecord) {
            self->_inList = YES;
        }
        self.data = [NSMutableArray arrayWithArray:model.records];
        [self addHeadView];
        [self.header setModel:model];
        [self setHeaderImage];
        [self.table reloadData];
    } failureComplection:^(NSDictionary * _Nonnull done) {
        [ToastManager showToast:done[@"msg"] inView:self.view];
    }];
}

- (void)setHeaderImage {
    UIView *aBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.header.frame.size.height)];
    self.scrollImage = [[UIImageView alloc] initWithFrame:aBg.bounds];
    UIImage *bg = [self makeImageWithView:self.header withSize:self.scrollImage.frame.size];
    bg = [bg stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    self.scrollImage.image = bg;
    [aBg addSubview:self.scrollImage];
    self.table.tableHeaderView = aBg;
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
    AcceptLuckyMoneyCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"AcceptLuckyMoneyCell"];
    if (indexPath.row < self.data.count) {
        cell.record = self.data[indexPath.row];
    }
    return cell;
}

- (void)initUI {
    self.bar = [[PresentNavigationBar alloc] init];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.bar.lineView setHidden:YES];
    [self.bar showBackImage];
    [self.bar.backBtn setImage:[UIImage imageNamed:@"detail_goback"] forState:UIControlStateNormal];
    [self.bar.backBtn setImage:[UIImage imageNamed:@"detail_goback"] forState:UIControlStateHighlighted];
    CGRect backFrame = self.bar.backBtn.frame;
    CGFloat backX = backFrame.origin.x;
    self.bar.backBtn.frame = CGRectMake(backX, backFrame.origin.y, backFrame.size.width, backFrame.size.height);
    [self.bar layoutIfNeeded];
    self.bar.backgroundColor = [UIColor colorWithRed:242/255.0 green:85/255.0 blue:65/255.0 alpha:1.0];
    [self.bar.backBtn addTarget:self action:@selector(backCLick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bar];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addHeadView {
    self.header = [HasInRobedResultList createViewFromNib];
    self.header.isAgroup = self.isGroup;
    CGFloat rHeight = 340;
    UIBezierPath *bezierPath;
    if (_inList == NO) {
        rHeight = 215;
        [self.header notInList];
        bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(gScreenWidth/2, -315) radius:180 +260 startAngle:(M_PI) endAngle:(M_PI*2) clockwise:NO];
    } else {
        bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(gScreenWidth/2, -190) radius:180 + 260 startAngle:(M_PI) endAngle:(M_PI*2) clockwise:NO];
    }
    self.header.frame = CGRectMake(0, 0, self.view.frame.size.width,rHeight);
    [self.header layoutSubviews];
    self.table.tableHeaderView = self.header;
    self.shaperLayer = [[CAShapeLayer alloc] init];
    self.shaperLayer.frame = self.header.bgRed.bounds;
    _layerHeight = self.header.bgRed.frame.size.height;
    self.shaperLayer.path = bezierPath.CGPath;
    self.header.bgRed.layer.mask = self.shaperLayer;
    _headerHeight = rHeight;
}

- (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollImage == nil) { return; }
    
    CGPoint offset = scrollView.contentOffset;
    //判断是否改变
    if (offset.y < 0) {
        CGRect rect = self.scrollImage.frame;
        //我们只需要改变图片的y值和高度即可
        rect.origin.y = offset.y;
        rect.size.height = _headerHeight - offset.y;
        self.scrollImage.frame = rect;
    }
}

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bar.frame), gScreenWidth, gScreenHeight - self.bar.frame.size.height) style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.rowHeight = 74;
        _table.backgroundColor = [UIColor whiteColor];
        [_table registerNib:[UINib nibWithNibName:@"AcceptLuckyMoneyCell" bundle:[NSBundle bundleForClass:[self class]]] forCellReuseIdentifier:@"AcceptLuckyMoneyCell"];
//        _table.bounces = NO;
        [self.view addSubview:_table];
    }
    return _table;
}


@end
