//
//  Predefine.h
//  WFChat UIKit
//
//  Created by WF Chat on 2017/10/29.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//
#ifndef Predefine_h
#define Predefine_h

#define IOS_SYSTEM_VERSION_LESS_THAN(v)                                     \
([[[UIDevice currentDevice] systemVersion]                                   \
compare:v                                                               \
options:NSNumericSearch] == NSOrderedAscending)


#define RGBCOLOR(r, g, b) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:1]
#define RGBACOLOR(r, g, b, a) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:(a)]
#define HEXCOLOR(rgbValue)                                                                                             \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0                                               \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0                                                  \
blue:((float)(rgbValue & 0xFF)) / 255.0                                                           \
alpha:1.0]
#define REDColor ([UIColor colorWithRed:248/255.0 green:82/255.0 blue:81/255.0 alpha:1.0])

#define SDColor(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]

#define Global_tintColor [UIColor colorWithRed:0 green:(190 / 255.0) blue:(12 / 255.0) alpha:1]

#define Global_mainBackgroundColor SDColor(248, 248, 248, 1)

#define TimeLineCellHighlightedColor [UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0]

#define DAY @"day"

#define NIGHT @"night"

//是否iPhoneX YES:iPhoneX屏幕 NO:传统屏幕
#define kIs_iPhoneX ([UIScreen mainScreen].bounds.size.height > 811.0f ||[UIScreen mainScreen].bounds.size.height == 896.0f )

#define kStatusBarAndNavigationBarHeight (kIs_iPhoneX ? 88.f : 64.f)

#define  kTabbarSafeBottomMargin        (kIs_iPhoneX ? 34.f : 0.f)
#define  gSafeAreaInsets     (kIs_iPhoneX ? UIEdgeInsetsMake(44, 0, 34, 0) : UIEdgeInsetsMake(20, 0, 0, 0))
#define gScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define gScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define kMessageListChanged  @"kMessageListChanged"
#define kTargetName @""
#define WFCU_SUPPORT_VOIP 1
#define WechatFont(x) ([UIFont fontWithName:@"WeChat Sans SS" size:x])
#define WFCString(key) [ZBLocalized localized:key table:@"wfc"]
#define LUCKMONEY_TITLE_COLOR ([UIColor colorWithRed:255/255.0 green:219/255.0 blue:162/255.0 alpha:1.0])
#endif /* Predefine_h */
