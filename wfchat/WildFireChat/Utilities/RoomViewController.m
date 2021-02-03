//
//  RoomViewController.m
//  WildFireChat
//
//  Created by ccc on 2018/11/18.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "RoomViewController.h"
#import "ClubChatRoomViewController.h"
#import <WFChatUIKit/WFChatUIKit.h>
//#import "MJExtension.h"
#import "SDCycleScrollView.h"
#import "ADModel.h"
#import "ADDetailViewController.h"
#import "SDWebImage.h"
#import <WFChatClient/WFCChatClient.h>
#import "SearchResultTableViewController.h"

#define imageCount 2//图片的张数
//当前设备的屏幕宽度
#define kkScreenWidth [UIScreen mainScreen].bounds.size.width
//当前设备的屏幕高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
static CGFloat cellWidth = 100;
static CGFloat cellHeight = 150;
static NSInteger pageNumber = 0;//用于记录计时器计时循环


@implementation GameView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    NSString *name = @"";
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    image.frame = CGRectMake(0, 0, cellWidth, cellHeight);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, cellWidth, 32)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = Tools.getThemeColor;
    label.font = [UIFont boldSystemFontOfSize:30];
    
    UIView *s = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
//    image.layer.masksToBounds = YES;
//    image.layer.cornerRadius = 10;
    [s addSubview:image];
    [s addSubview:label];
    [self addSubview:s];
    self.bgImageView = image;
    image.userInteractionEnabled = YES;
    self.textLabel = label;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
    
//    UIImage *x = [UIImage imageNamed:@"labi_btn"];
//    UIImageView *xx = [[UIImageView alloc] initWithImage:x];
//    [self addSubview:xx];
//    xx.frame = CGRectMake(15 ,cellHeight - 45, cellWidth - 30, 30);
}

- (void)tap {
    if (self.block) {
        self.block(self.index);
    }
}

@end

@interface RoomViewController ()<SDCycleScrollViewDelegate> {
    UILabel *_roomLabel;
    UILabel *_zhanweiLabel;
    NSMutableArray <ADModel*>*_ads ;
    UIImageView *_zhanwei;
    NSMutableArray <ADModel*>*_games;
    NSMutableArray *_allView;
    UIScrollView *_bSC;
}

@property (nonatomic, strong) SDCycleScrollView *sc;
@property(nonatomic,strong)UIPageControl * pageController;//页面控制器
@property(nonatomic,strong)NSTimer * timer;//计时器
@end

@implementation RoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    cellWidth = (kkScreenWidth - 70 - 14)/2;
    cellHeight = (cellWidth * 457)/288;
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.image = [UIImage imageNamed:@"beiying"];
    [self.view addSubview:bg];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beiying"]];
    [self initView];
    _ads = [NSMutableArray arrayWithCapacity:3];
    _games = [NSMutableArray arrayWithCapacity:3];
    _allView = [NSMutableArray arrayWithCapacity:3];
    [self loadFromData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:kChangeLanguageNofiName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchResult:) name:@"kSearchResultNotificationName" object:nil];
    [self isRegisterMoney];
    
    UIView *t = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labi_main_home"]];
    self.navigationItem.titleView = t;
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
//    UIView *red = [[UIView alloc] initWithFrame:CGRectMake(200, 200, 50, 50)];
//    red.backgroundColor = UIColor.redColor;
//    [self.view addSubview:red];
//    [self.view bringSubviewToFront:red];
    
}

- (void)searchResult:(NSNotification *)nofi {
    if ([nofi.object isKindOfClass:UIViewController.class]) {
        UIViewController *v = nofi.object;
        NSDictionary *dic = nofi.userInfo;
        SearchResultTableViewController *vc = [SearchResultTableViewController new];
        vc.model = [ShowModel mj_objectWithKeyValues:dic];
        [v.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)isRegisterMoney {
    __weak typeof(self) weakself = self;
    [[UserInfo sharedInstance] updateWallet:^(NSDictionary *done) {
        BOOL isTrue = [done[@"hasWallet"] integerValue];
        NSInteger status = 0;
        if (isTrue) {
            status = [done[@"status"] integerValue];
        } else {
            status = [done[@"status"] integerValue];
        }
        if (status == 1001) {
            [weakself autoNeedCreate];
        }
    }];
}
 
- (void)autoNeedCreate {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *str = [self addPassword];
    param[@"payNumber"] = str;
    param[@"userId"] = [WFCCNetworkService sharedInstance].userId;;
    [ToastManager showText:@"" inView:self.view];
    [[NetworkAPI sharedInstance] postWithUrl:WALLET_CREATE params:param successComplection:^(NSDictionary * _Nonnull done) {
        [UserInfo sharedInstance].money = [NSString stringWithFormat:@"%@",done[@"data"][@"money"]];
        [UserInfo sharedInstance].hasWallet = YES;
    } failureComplection:^(NSDictionary * _Nonnull done) {
        [ToastManager showToast:done[@"msg"] inView:self.view];
    }];
}

- (NSString *)addPassword {
    int a = 1;
    int b = 3;
    int c = 4;
    int i = 2*a + 2*b + 2*c - a - b - c + 1000 - 1000;
    NSMutableString *str = [NSMutableString stringWithCapacity:8];
    for (int j = 0; j<6; j++) {
        NSString *str1 = [NSString stringWithFormat:@"%d", i];
        [str appendString:str1];
    }
    return str;
    
}


- (void)changeLanguage {
    _roomLabel.text = LocalizedString(@"GentingClub");
    _zhanweiLabel.text = LocalizedString(@"ComingSoon");
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
//    NSString *u = _ads[index].url;
//    NSURL *url = [NSURL URLWithString:u];
//    ADDetailViewController *avc = [ADDetailViewController new];
//    avc.url = url;
//    [self.navigationController pushViewController:avc animated:YES];
}
#pragma mark -- 初始化视图
- (void)showads:(NSArray *)urls {
    [_sc removeFromSuperview];
    _sc = [SDCycleScrollView cycleScrollViewWithFrame:_zhanwei.frame imageURLStringsGroup:urls];
    _sc.delegate = self;
    [self.view addSubview:_sc];
}
#pragma mark -- 初始化对象
-(void)loadFromData{
    [[NetworkAPI sharedInstance] v2GetWithUrl:APP_ADS_V2  successComplection:^(NSDictionary * _Nonnull done) {
        NSArray *array = done[@"data"];
        if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
            [_ads removeAllObjects];
            _ads = [ADModel mj_objectArrayWithKeyValuesArray:array];
            NSMutableArray *urls = [NSMutableArray arrayWithCapacity:3];
            for (ADModel *model in _ads) {
                NSURL *u = [NSURL URLWithString:model.img];
                [urls addObject:u];
            }
            if (urls.count > 0) {
                [self showads:urls];
            }
            NSLog(@"%@", _ads);
        }
    } failureComplection:^(NSDictionary * _Nonnull done) {
        NSLog(@"%@", done);
    }];
    [self loadGames];
}

-(void)initView{
    //添加ScrollView
    self.navigationController.navigationBar.translucent = NO;
    CGFloat h = (kkScreenWidth / 750) * 353;
    UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kkScreenWidth, h)];
    imageV.image = [UIImage imageNamed:@"bander3.jpg"];
    [self.view addSubview:imageV];
    _zhanwei = imageV;
    
    
    _bSC = [UIScrollView new];
    _bSC.frame = CGRectMake(0, h, kkScreenWidth, self.view.frame.size.height - h);
    [self.view addSubview:_bSC];
}

- (void)addRoom {
    UIView *s1 = [self room:0];
    UIView *s2 = [self room:1];
    CGFloat x = (kkScreenWidth - 2 * cellWidth)/3;
    CGFloat h = (kkScreenWidth / 750) * 353;
    CGFloat y = h + x;
    s1.frame = CGRectMake(x, y, s1.frame.size.width, s1.frame.size.height);
    s2.frame = CGRectMake(x * 2 + cellWidth, y, s1.frame.size.width, s1.frame.size.height);
    [self.view addSubview:s1];
    [self.view addSubview:s2];
//    _roomLabel.text = LocalizedString(@"GentingClub");
//    _zhanweiLabel.text = LocalizedString(@"ComingSoon");
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterRoom)];
    [s1 addGestureRecognizer:tap];
}

- (void)enterRoom {
    ClubChatRoomViewController *vc = [ClubChatRoomViewController new];
    vc.title = LocalizedString(@"Chatroom");
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadGames {
    [[NetworkAPI sharedInstance] v2GetWithUrl:APP_GAMES_V2  successComplection:^(NSDictionary * _Nonnull done) {
        NSArray *array = done[@"data"];
        if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
            [_games removeAllObjects];
            _games = [ADModel mj_objectArrayWithKeyValuesArray:array];
            if (_games.count > 0) {
                [self showGames:_games];
            }
            NSLog(@"%@", _ads);
        }
    } failureComplection:^(NSDictionary * _Nonnull done) {
        NSLog(@"%@", done);
    }];
}

- (void)toYyouxi:(ADModel *)model {
    ClubChatRoomViewController *vc = [ClubChatRoomViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = model.type;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadFromData];
}
#pragma mark -- 初始化视图
- (void)showGames:(NSArray <ADModel *> *)urls {
    for (UIView *v in _allView) {
        [v removeFromSuperview];
    }
    _bSC.contentSize = CGSizeMake(0, 0);
//    CGFloat x = (kkScreenWidth - 2 * cellWidth)/3;
//    CGFloat h = (kkScreenWidth / 750) * 353;
    NSInteger a = 0;
    for (ADModel *model in _games) {
        GameView *g = [[GameView alloc] init];
        CGFloat xx = a % 2 == 0 ? 30 : (45 + cellWidth);
        CGFloat yy = a/2 * (cellHeight + 30) + 60;
        g.frame = CGRectMake(xx, yy, cellWidth, cellHeight);
        [_bSC addSubview:g];
        [_allView addObject:g];
        g.index = a;
        g.block = ^(NSInteger index) {
            ADModel *model = _games[index];
            [self toYyouxi:model];
        };
        a = a + 1;
        _bSC.contentSize = CGSizeMake(0, a * cellWidth);
        [g.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"GentingClubLeft"]];
//        g.textLabel.text = model.name;
    }
}


- (UIView *)room:(NSInteger)index {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellWidth)];
    v.backgroundColor = UIColor.blackColor;
    NSString *name = @"GentingClubLeft";
    if (index == 1) {
        name = @"GentingClubright";
    }
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    image.frame = CGRectMake(8, 8, cellWidth - 16, cellWidth - 16);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 127, cellWidth, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = Tools.getThemeColor;
    
    label.font = [UIFont systemFontOfSize:16];
    
    UIView *s = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 147)];
    if (index == 0) {
        _roomLabel = label;
    } else {
        _zhanweiLabel = label;
    }
    v.layer.masksToBounds = YES;
    v.layer.cornerRadius = 10;
    [s addSubview:v];
    [s addSubview:image];
    [s addSubview:label];
    return s;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
