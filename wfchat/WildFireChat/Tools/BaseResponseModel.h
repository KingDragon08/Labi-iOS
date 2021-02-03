//
//  BaseResponseModel.h
//  WildFireChat
//
//  Created by xxx on 2019/11/14.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseResponseModel : NSObject

@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) id data;
@property (nonatomic, copy) NSString *msg;

- (BOOL) isSuccess;

@end

NS_ASSUME_NONNULL_END
