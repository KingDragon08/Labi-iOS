//
//  Tools.h
//  WildFireChat
//
//  2019/10/29.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define kChangeLanguageNofiName @"kChangeLanguageNofiName"
#define COLOR(rgbValue)                                                                                             \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0                                               \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0                                                  \
blue:((float)(rgbValue & 0xFF)) / 255.0                                                           \
alpha:1.0]
NS_ASSUME_NONNULL_BEGIN

@interface Tools : NSObject

+ (UIColor *) getThemeColor;
+ (NSString *)uuid;

@end

NS_ASSUME_NONNULL_END
