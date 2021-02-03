//
//  ClubCollectionViewCell.h
//  WildFireChat
//
//  Created by ccc on 2018/11/18.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WFChatClient/WFCChatClient.h>
#import "RoomModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ClubCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)RoomModel *info;
@property (weak, nonatomic) IBOutlet UILabel *onLineCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *roomImage;
@property (weak, nonatomic) IBOutlet UILabel *roomName;
@property (weak, nonatomic) IBOutlet UIImageView *staticRoom;

@end

NS_ASSUME_NONNULL_END
