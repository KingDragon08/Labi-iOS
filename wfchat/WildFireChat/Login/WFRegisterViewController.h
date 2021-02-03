//
//  WFRegisterViewController.h
//  WildFireChat
//
//  Created by xxxty on 2018/2/25.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RegisterIMBlock)(NSString *token);

NS_ASSUME_NONNULL_BEGIN

@interface WFRegisterViewController : UIViewController
@property (nonatomic, strong) RegisterIMBlock block;
@end

NS_ASSUME_NONNULL_END
