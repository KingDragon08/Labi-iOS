//
//  PluginBoardView.h
//  WFChat UIKit
//
//  Created by WF Chat on 2017/10/29.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBLocalized.h"

@protocol WFCUPluginBoardViewDelegate <NSObject>
- (void)onItemClicked:(NSUInteger)itemTag;
@end

@interface WFCUPluginBoardView : UIView
- (instancetype)initWithDelegate:(id<WFCUPluginBoardViewDelegate>)delegate withVoip:(BOOL)withVoip isSingleChat:(BOOL) single;
@end
