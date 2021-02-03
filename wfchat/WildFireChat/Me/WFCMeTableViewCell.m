//
//  MeTableViewCell.m
//  WildFireChat
//
//  Created by WF Chat on 2018/10/2.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "WFCMeTableViewCell.h"
#import "SDWebImage.h"
#import <WFChatUIKit/WFChatUIKit.h>

static CGFloat jiFenHeight = 165;
static CGFloat bgHeight = 70;
static CGFloat kLeftSpace = 20;

@interface WFCMeTableViewCell () {
    UILabel *xxlabel1;
    UILabel *xxlabel2;
}


@property (nonatomic, strong) UILabel *accountLabel;

@property (nonatomic, strong) UIView *bgView;
@property (strong, nonatomic) UIImageView *portrait;
@property (nonatomic, strong) UILabel *nickName;

@property (nonatomic, strong) UILabel *timeLabel;

@property (strong, nonatomic) UILabel *displayName;

@property (nonatomic, strong) UIButton *chongzhi;
@property (nonatomic, strong) UIButton *tixian;


@property (nonatomic, strong) UIButton *zhuanyue;
@property (nonatomic, strong) UIButton *fresh;




@end

@implementation WFCMeTableViewCell
+ (CGFloat)cellHeight {
    return jiFenHeight + bgHeight;
}
- (void)changeLanguage {
    [self.zhuanyue setTitle:LocalizedString(@"ExcnangeToMoney") forState:UIControlStateNormal];
    [self.chongzhi setTitle:LocalizedString(@"Recharge") forState:UIControlStateNormal];
    [self.tixian setTitle:LocalizedString(@"Withdrawal") forState:UIControlStateNormal];
    [self.fresh setTitle:LocalizedString(@"Refresh") forState:UIControlStateNormal];
}
- (void)awakeFromNib {
    [super awakeFromNib];
   
    // Initialization code
}

- (void)resetDisplayName:(NSString *)name {
    if (name == nil || name.length == 0) {
        return;
    }
    NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:name];
    NSTextAttachment *image = [NSTextAttachment new];
    image.image = [UIImage imageNamed:@"editname"];
    image.bounds = CGRectMake(4, 0, 14, 14);
    NSAttributedString *s = [NSAttributedString attributedStringWithAttachment:image];
    [mstr appendAttributedString:s];
    self.nickName.attributedText = mstr;
}

- (void)fixHeader {
    if (self.block) {
        self.block(0);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIView *)bgView {
    if(!_bgView) {
        
        UIView *xx = [[UIView alloc] initWithFrame:CGRectMake(10, 10, UIScreen.mainScreen.bounds.size.width - 20, [WFCMeTableViewCell cellHeight])];
        UIImageView *ii = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labi_banner"]];
        ii.frame = xx.bounds;
        [xx addSubview:ii];
        
//        xx.layer.borderWidth = 1.0/UIScreen.mainScreen.scale;
//        xx.layer.cornerRadius = 2.0;
//        xx.layer.borderColor = Tools.getThemeColor.CGColor;
        [self.contentView addSubview:xx];
        
        CGFloat kWidth = UIScreen.mainScreen.bounds.size.width;
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, [WFCMeTableViewCell cellHeight])];
        _bgView.frame = CGRectMake(0, 0, kWidth, bgHeight + jiFenHeight);
        UIImageView *bg = [[UIImageView alloc] init];
        bg.backgroundColor = UIColor.clearColor;
        bg.frame = _bgView.bounds;
        [_bgView addSubview:bg];
        UIView *jifenbg = [[UIView alloc] initWithFrame:CGRectMake(0, bgHeight, kWidth, jiFenHeight)];
        [_bgView addSubview:jifenbg];
        
        UIView *aa = [UIView new];
        aa.frame = CGRectMake(15, bgHeight, kWidth - 30, jiFenHeight);
        [_bgView addSubview:aa];
//        aa.backgroundColor = COLOR(0x1D1D1D);
//        aa.layer. =
//        aa.layer.masksToBounds = YES;
//        aa.layer.cornerRadius = 2.0;
        
        UIView *a1 = [UIView new];
        a1.frame = CGRectMake(0, bgHeight + 20, kWidth/2, jiFenHeight);
        [_bgView addSubview:a1];
        
        
        CGFloat labelHeight1 = 20;
        CGFloat labelTopSpace = 10;
        
        UILabel *label1 = [self getCustomLabel:YES];
        label1.text = LocalizedString(@"Integral");
        xxlabel1 = label1;
        label1.frame = CGRectMake(0, 50, kWidth/2, labelHeight1);
        [a1 addSubview:label1];
        
        UILabel *label12 = [self getCustomLabel:YES];
        label12.textColor = UIColor.whiteColor;
        label12.frame = CGRectMake(label1.frame.origin.x, CGRectGetMaxY(label1.frame) + 5, label1.frame.size.width, labelHeight1);
        [a1 addSubview:label12];
        self.jifen = label12;
        
        UIView *a2 = [UIView new];
        a2.frame = CGRectMake(kWidth/2, a1.frame.origin.y, kWidth/2, jiFenHeight);
        [_bgView addSubview:a2];
        
        UILabel *label2 = [self getCustomLabel:YES];
        label2.text = LocalizedString(@"MoneyBlance");
        xxlabel2 = label2;
        label2.frame = CGRectMake(0, label1.frame.origin.y, label1.frame.size.width, labelHeight1);
        [a2 addSubview:label2];
        
        UILabel *label22 = [self getCustomLabel:YES];
        label22.textColor = UIColor.whiteColor;

        label22.frame = CGRectMake(label2.frame.origin.x, label12.frame.origin.y, label2.frame.size.width, labelHeight1);
        [a2 addSubview:label22];
        self.hongbao = label22;
        
        [a1 addSubview:self.chongzhi];
        self.chongzhi.frame = CGRectMake(0, CGRectGetMaxY(label12.frame) + 10, a1.frame.size.width, 45);
        
        [a2 addSubview:self.tixian];
        self.tixian.frame = CGRectMake(0, CGRectGetMaxY(label22.frame) + 10, a1.frame.size.width, 45);
       
        [self.contentView addSubview:_bgView];
        
        UIImageView *bgxx = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        [_bgView addSubview:self.portrait];
        CGFloat lineW = 1/UIScreen.mainScreen.scale;
        UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(50, a1.frame.origin.y - 2 + 45,  kWidth - 100, lineW)];
        line1.hidden = YES;
        line1.backgroundColor = Tools.getThemeColor;
        [_bgView addSubview:line1];
        
        UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(50, a1.frame.origin.y + 100, line1.frame.size.width , lineW)];
        line2.backgroundColor = Tools.getThemeColor;
        line2.hidden = YES;
        [_bgView addSubview:line2];
        
        UIImageView *line3 = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/2, CGRectGetMaxY(line1.frame) + 8, lineW, 40)];
        line3.backgroundColor = Tools.getThemeColor;
        line3.hidden = YES;
        [_bgView addSubview:line3];
        
        UIImageView *line4 = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/2, CGRectGetMaxY(line2.frame) + 8, lineW, 40)];
        line4.backgroundColor = Tools.getThemeColor;
        line4.hidden = YES;
        [_bgView addSubview:line4];
        
        self.nickName = [self getCustomLabel:YES];
        self.nickName.font = [UIFont boldSystemFontOfSize:20];
        self.nickName.textAlignment = NSTextAlignmentCenter;
        self.nickName.frame = CGRectMake(50, 90, kWidth - 100, 40);
        self.nickName.textColor = Tools.getThemeColor;
        self.nickName.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeDispalyName)];
        [self.nickName addGestureRecognizer:tap];
        [_bgView addSubview:self.nickName];
    }
    return _bgView;
}

- (UILabel *)getCustomLabel:(BOOL)left {
    UILabel *label = [UILabel new];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textColor = Tools.getThemeColor;
    label.text = @"";
    label.textAlignment = NSTextAlignmentCenter;
//    left ? NSTextAlignmentLeft : NSTextAlignmentRight;
    return label;
}

- (UIImageView *)portrait {
    if (!_portrait) {
        CGFloat h = 70;
        CGFloat t = 20;
        _portrait = [[UIImageView alloc] initWithFrame:CGRectMake((_bgView.frame.size.width - h)/2, t, h, h)];
        _portrait.layer.masksToBounds = YES;
        _portrait.layer.cornerRadius = h/2;
        _portrait.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fixHeader)];
        [_portrait addGestureRecognizer:tap];
        [self.contentView addSubview:_portrait];
    }
    return _portrait;
}

- (UILabel *)displayName {
    if (!_displayName) {
        _displayName = [[UILabel alloc] initWithFrame:CGRectMake(40, 110, [UIScreen mainScreen].bounds.size.width - 80, 22)];
        [_displayName setFont:[UIFont systemFontOfSize:18]];
        _displayName.userInteractionEnabled = YES;
        [self.contentView addSubview:_displayName];
    }
    return _displayName;
}

- (UIButton *)zhuanyue {
    if (!_zhuanyue) {
        _zhuanyue = [UIButton new];
        [_zhuanyue setTitle:LocalizedString(@"ExcnangeToMoney") forState:UIControlStateNormal];
        _zhuanyue.frame = CGRectMake(0, 0, 100, 44);
        _zhuanyue.titleLabel.font = [UIFont systemFontOfSize:15];
        [_zhuanyue addTarget:self action:@selector(zhuanyueClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zhuanyue;
}

- (UIButton *)chongzhi {
    if (!_chongzhi) {
        _chongzhi = [UIButton new];
        [_chongzhi setTitle:LocalizedString(@"Recharge") forState:UIControlStateNormal];
        [_chongzhi setImage:[UIImage imageNamed:@"chongzhi"] forState:UIControlStateNormal];
        _chongzhi.frame = CGRectMake(0, 0, 44, 44);
        _chongzhi.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [_chongzhi addTarget:self action:@selector(chongzhiClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chongzhi;
}

- (UIButton *)tixian {
    if (!_tixian) {
        _tixian = [UIButton new];
        [_tixian setTitle:LocalizedString(@"Withdrawal") forState:UIControlStateNormal];
        [_tixian setImage:[UIImage imageNamed:@"tixian"] forState:UIControlStateNormal];
        _tixian.frame = CGRectMake(0, 0, 44, 44);
        _tixian.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [_tixian addTarget:self action:@selector(tixianClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tixian;
}
- (UIButton *)fresh {
    if (!_fresh) {
        _fresh = [UIButton new];
        [_fresh setTitle:LocalizedString(@"Refresh") forState:UIControlStateNormal];
        _fresh.frame = CGRectMake(0, 0, 44, 44);
        _fresh.titleLabel.font = [UIFont systemFontOfSize:15];
        [_fresh addTarget:self action:@selector(zhuanyueClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fresh;
}


- (void)chongzhiClick {
    if (self.delegate) {
        [self.delegate chongzhi];
    }
}

- (void)refreshClick {
    if (self.delegate) {
        [self.delegate refresh];
    }
}

- (void)zhuanyueClick {
    if (self.delegate) {
        [self.delegate zhuanyue];
    }
}

- (void)tixianClick {
    if (self.delegate) {
        [self.delegate tixian];
    }
}


- (UILabel *)accountLabel {
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 44, [UIScreen mainScreen].bounds.size.width - 80, 22)];
        [_accountLabel setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:_accountLabel];
    }
    return _accountLabel;
}

- (void)changeDispalyName {
    if (_userInfo.displayName.length > 0 && self.block) {
        self.block(1);
    }
}

- (void)setUserInfo:(WFCCUserInfo *)userInfo {
    _userInfo = userInfo;
    self.bgView.backgroundColor = UIColor.clearColor;
    [self.portrait sd_setImageWithURL:[NSURL URLWithString:self.userInfo.portrait] placeholderImage: [UIImage imageNamed:@"PersonalChat"]];
    self.nickName.text = self.userInfo.name;
    xxlabel1.text = LocalizedString(@"GamePoints");
    xxlabel2.text = LocalizedString(@"Balance");
    self.hongbao.text = [[UserInfo sharedInstance] getMoneyStr];
    [self resetDisplayName:_userInfo.displayName];
}
@end
