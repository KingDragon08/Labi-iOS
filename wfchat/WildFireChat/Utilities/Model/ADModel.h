//
//  ADModel.h
//  WildFireChat
//
//  xxxxx on 2018/11/28.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFChatClient/WFCChatClient.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADModel : NSObject
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;

@end

NS_ASSUME_NONNULL_END
