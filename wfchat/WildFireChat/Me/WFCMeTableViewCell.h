//
//  MeTableViewCell.h
//  WildFireChat
//
//  Created by WF Chat on 2018/10/2.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WFChatClient/WFCChatClient.h>

@protocol UserInfoHeadProtocol <NSObject>

- (void)tixian;
- (void)chongzhi;
- (void)zhuanyue;
- (void)refresh;

@end

typedef void(^VoidBlock)(NSInteger type);
NS_ASSUME_NONNULL_BEGIN

@interface WFCMeTableViewCell : UITableViewCell
@property(nonatomic, strong)WFCCUserInfo *userInfo;
@property (nonatomic,copy) VoidBlock block;

@property (nonatomic, weak) id<UserInfoHeadProtocol> delegate;
@property (nonatomic, strong) UILabel *jifen;
@property (nonatomic, strong) UILabel *hongbao;
- (void)changeLanguage;
+ (CGFloat)cellHeight;
- (void)resetDisplayName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
