//
//  VideoCell.h
//  WFChat UIKit
//
//  Created by WF Chat on 2017/9/2.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#import "WFCUMediaMessageCell.h"
#import "ZBLocalized.h"

@interface WFCUVideoCell : WFCUMediaMessageCell
@property (nonatomic, strong)UIImageView *thumbnailView;
@property (nonatomic, strong)UIImageView *videoCoverView;
@property (nonatomic, strong)UILabel *durationLabel;
@end
