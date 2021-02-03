//
//  WFUserModel.h
//  WildFireChat
//
//  xxxxx on 2018/11/28.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface WFUserModel : NSObject
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *portrait;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *clientId;
@property (nonatomic, strong) NSString *imToken;
@property (nonatomic, strong) NSString *extra;
@property (nonatomic, strong) NSString *createdAt;

@property (nonatomic, strong) NSString *shareCode;
@property (nonatomic, strong) NSString *agent;
@property (nonatomic, strong) NSString *jifen;
@property (nonatomic, strong) NSString *shareCoderegCode;

@property (nonatomic, strong) NSString *bank;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *realName;

@property (nonatomic, assign) NSInteger crash;
@end

NS_ASSUME_NONNULL_END
