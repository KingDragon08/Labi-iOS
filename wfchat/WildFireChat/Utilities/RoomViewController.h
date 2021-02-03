//
//  RoomViewController.h
//  WildFireChat
//
//  Created by ccc on 2018/11/18.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GameClick)(NSInteger index);
NS_ASSUME_NONNULL_BEGIN

@interface RoomViewController : UIViewController

@end

@interface GameView : UIView
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) GameClick block;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *textLabel;
@end

NS_ASSUME_NONNULL_END
