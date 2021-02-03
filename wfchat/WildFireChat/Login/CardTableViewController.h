//
//  CardTableViewController.h
//  WildFireChat
//
//  Created by xxx on 2018/12/12.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardModel.h"
#import "WFCMeTableViewController.h"
typedef void(^CardSelectBlock)(NSString *card);
NS_ASSUME_NONNULL_BEGIN

@interface CardTableViewController : UITableViewController
@property (nonatomic, copy) CardSelectBlock block;
@property (nonatomic, assign) BOOL bind;
@property (nonatomic, strong) CardModel *model;
@end

NS_ASSUME_NONNULL_END
