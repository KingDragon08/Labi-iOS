//
//  ClubChatRoomViewController.m
//  WildFireChat
//
//  Created by ccc on 2018/11/18.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "ClubChatRoomViewController.h"
#import "ClubCollectionViewCell.h"
#import <WFChatClient/WFCChatClient.h>
#import <WFChatUIKit/WFCUMessageListViewController.h>
#import <WFChatUIKit/WFChatUIKit.h>
#define kkkScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ClubChatRoomViewController ()<UICollectionViewDelegate, UICollectionViewDataSource> {
    CGFloat _space;
    NSMutableArray <RoomModel*>*_games;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray<WFCCConversationInfo *> *conversations;
@end

@implementation ClubChatRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _games = [NSMutableArray arrayWithCapacity:3];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beiying"]];
    [self initCollection];
    [self group];
    [self loadRooms];
}

- (void)group {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGroupInfoUpdated:) name:kGroupInfoUpdated object:nil];
//    [self refreshList];
}

- (void)refreshList {
  self.conversations = [[[WFCCIMService sharedWFCIMService] getConversationInfos:@[@(Group_Type)] lines:@[@(0)]] mutableCopy];
  [self.collectionView reloadData];
}

- (void)loadRooms {
    [[NetworkAPI sharedInstance] v2GetWithUrl:APP_ROOMS_V2 params:@{@"type":self.type} successComplection:^(NSDictionary * _Nonnull done) {
        NSArray *array = done[@"data"];
        if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
            [_games removeAllObjects];
            _games = [RoomModel mj_objectArrayWithKeyValuesArray:array];
            if (_games.count > 0) {
                [self.collectionView reloadData];
            }
        }
    } failureComplection:^(NSDictionary * _Nonnull done) {
        NSLog(@"%@", done);
    }];
}


- (void)onGroupInfoUpdated:(NSNotification *)notification {
//    [self refreshList];
//    WFCCGroupInfo *groupInfo = notification.userInfo[@"groupInfo"];
//    NSArray *dataSource = self.conversations;
//    for (int i = 0; i < dataSource.count; i++) {
//        WFCCConversationInfo *conv = dataSource[i];
//        if (conv.conversation.type == Group_Type && [conv.conversation.target isEqualToString:groupInfo.target]) {
//            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]];
//        }
//    }
}

- (void)initCollection {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _space = (kkkScreenWidth - 100*2)/4;
    flowLayout.minimumLineSpacing = 40;
//    flowLayout.minimumInteritemSpacing = 140;
    flowLayout.itemSize = CGSizeMake(100, 145);
    //设置CollectionView的属性
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ClubCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ClubCollectionViewCell"];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beiying"]];
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(100, 145);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _games.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= _games.count) {
        return  [ClubCollectionViewCell new];
    }
    ClubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClubCollectionViewCell" forIndexPath:indexPath];
    cell.info = _games[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= _games.count) {
        return;
    }
    RoomModel *r = _games[indexPath.item];
    NSString *str = r.rules;
    
//    UIAlertController *av = [UIAlertController alertControllerWithTitle:@"" message:str preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:LocalizedString(@"DissAgree") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//    }];
//
//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:LocalizedString(@"Agree") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [self toGroupChatroom:indexPath.row];
//    }];
//    [av addAction:action2];
//    [av addAction:action1];
//    [self presentViewController:av animated:YES completion:nil];
    
    [LEEAlert alert].config
    .LeeAddContent(^(UILabel * _Nonnull label) {
        label.text = str;
        label.textAlignment = NSTextAlignmentLeft;
    })
    .LeeCancelAction(LocalizedString(@"DissAgree"), ^{
        
    })
    .LeeAction(LocalizedString(@"Agree"), ^{
        [self toGroupChatroom:indexPath.row];
    }).LeeShow();
}
- (void)toGroupChatroom:(NSInteger)row {
    RoomModel *model = _games[row];
    NSString *userId = [WFCCNetworkService sharedInstance].userId;
    [[NetworkAPI sharedInstance] v2GetWithUrl:APP_JOIN_V2 params:@{@"room":model.sn, @"user": userId} successComplection:^(NSDictionary * _Nonnull done) {
        NSDictionary *dic = done[@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
        if ([code isEqualToString:@"0"]) {
            WFCUMessageListViewController *mvc = [[WFCUMessageListViewController alloc] init];
            mvc.conversation = [WFCCConversation conversationWithType:Group_Type target:model.sn line:0];
            mvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mvc animated:YES];
        }
    } failureComplection:^(NSDictionary * _Nonnull done) {
        NSLog(@"%@", done);
    }];
//    RoomModel *model = _games[row];
//    NSString *groupId = model.sn;
//    __block BOOL isContainMe = NO;
//    NSArray<WFCCGroupMember *> *members = [[WFCCIMService sharedWFCIMService] getGroupMembers:groupId forceUpdate:NO];
//    [members enumerateObjectsUsingBlock:^(WFCCGroupMember * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj.memberId isEqualToString:[WFCCNetworkService sharedInstance].userId]) {
//            *stop = YES;
//            isContainMe = YES;
//        }
//    }];
//    if (isContainMe)
//    [[WFCCIMService sharedWFCIMService] addMembers:@[[WFCCNetworkService sharedInstance].userId] toGroup:groupId notifyLines:@[@(0)] notifyContent:nil success:^{
//        [[WFCCIMService sharedWFCIMService] getGroupMembers:groupId forceUpdate:YES];
//    } error:^(int error_code) {
//        
//    }];
    
//    WFCUMessageListViewController *mvc = [[WFCUMessageListViewController alloc] init];
//    WFCCConversationInfo *info = self.conversations[row];
//    mvc.conversation = info.conversation;
//    mvc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:mvc animated:YES];
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section

{

return UIEdgeInsetsMake(40, _space, 0, _space);//分别为上、左、下、右

}

@end
