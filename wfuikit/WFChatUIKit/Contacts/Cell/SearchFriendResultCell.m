//
//  SearchFriendResultCell.m
//  WFChatUIKit
//
//    on 2019/11/5.
//  Copyright © 2019 Tom Lee. All rights reserved.
//

#import "SearchFriendResultCell.h"
#import "SDWebImage.h"

@interface SearchFriendResultCell ()

@property (nonatomic, strong)UIImageView* portraitView;
@property (nonatomic, strong)UILabel* nameLabel;
@property (nonatomic, strong)UILabel* phoneLabel;
@end

@implementation SearchFriendResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void) setUserInfo:(WFCCUserInfo *)info {
     [self.portraitView sd_setImageWithURL:[NSURL URLWithString:[info.portrait stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"PersonalChat"]];
    self.nameLabel.text = info.displayName;
    if (info.mobile.length) {
        self.phoneLabel.text = [NSString stringWithFormat:@"手机号：%@",info.mobile];
    }
}

- (UIImageView *)portraitView {
    if (!_portraitView) {
        _portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 40, 40)];
        _portraitView.layer.masksToBounds = YES;
        _portraitView.layer.cornerRadius = 3.f;
        _portraitView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_portraitView];
    }
    return _portraitView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(63, 8, [UIScreen mainScreen].bounds.size.width - 56 - 48, 18)];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel {
    if(!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(63, 30, [UIScreen mainScreen].bounds.size.width - 56 - 48, 16)];
        _phoneLabel.font = [UIFont systemFontOfSize:14];
        _phoneLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_phoneLabel];
    }
    return _phoneLabel;
}


@end
