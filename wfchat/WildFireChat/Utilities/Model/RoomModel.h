//
//  RoomModel.h
//  WildFireChat
//
//  xxxxx on 2018/11/28.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoomModel : NSObject

@property (nonatomic, strong) NSString *owner;
@property (nonatomic, strong) NSString *updated_at;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *sn;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *rules;
@property (nonatomic, strong) NSString *name;
@end

NS_ASSUME_NONNULL_END
