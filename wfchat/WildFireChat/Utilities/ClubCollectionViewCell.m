//
//  ClubCollectionViewCell.m
//  WildFireChat
//
//  Created by ccc on 2018/11/18.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "ClubCollectionViewCell.h"
#import "SDWebImage.h"

@implementation ClubCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.roomImage.layer.masksToBounds = YES;
    self.roomImage.layer.cornerRadius = 10.0;
    self.staticRoom.layer.cornerRadius = 10.0;
    self.staticRoom.layer.masksToBounds = YES;
    self.backgroundColor = UIColor.clearColor;
    // Initialization code
}

- (void)setInfo:(RoomModel *)info {
    WFCCGroupInfo *groupInfo = [[WFCCIMService sharedWFCIMService] getGroupInfo:info.sn refresh:YES];
    if(groupInfo.target.length == 0) {
        
    }
    self.onLineCountLabel.text = [NSString stringWithFormat:@"%ld", groupInfo.memberCount];
    [self.roomImage sd_setImageWithURL:[NSURL URLWithString:info.avatar] placeholderImage:[UIImage imageNamed:@"group_default_portrait"]];
    self.roomName.text = info.name;
//    if(groupInfo.name.length > 0) {
//      self.roomName.text = groupInfo.name;
//    } else {
//      self.roomName.text = LocalizedString(@"GroupChat");
//    }
}

@end
