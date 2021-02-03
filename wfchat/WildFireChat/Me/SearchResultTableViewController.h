//
//  SearchResultTableViewController.h
//  WildFireChat
//
//  Created by xxx on 2018/12/15.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^ControllervcBlock)(UIViewController *vc);

@interface SearchResultTableHeaderView: UIView
@property (weak, nonatomic) IBOutlet UILabel *zhuang;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *boundsLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankerLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;



@end

@interface SearchResultTableViewController : UIViewController
@property (nonatomic, strong) ShowModel *model;
+ (UIViewController *)showResultWithStr:(NSString *)game;
@end

NS_ASSUME_NONNULL_END
