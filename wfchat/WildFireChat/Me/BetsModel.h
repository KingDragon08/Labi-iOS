//
//  BetsModel.h
//  WildFireChat
//
//  Created by xxx on 2018/12/15.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BetsModel : NSObject
@property (nonatomic, assign) NSInteger gameId;
@property (nonatomic, assign) NSInteger bet;
@property (nonatomic, strong) NSString *created_time;
@property (nonatomic, assign) NSInteger bonus;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) NSInteger win;

- (NSString *)betStr;

- (NSString *)bondsStr ;

- (NSString *)winStr ;
@end

NS_ASSUME_NONNULL_END
