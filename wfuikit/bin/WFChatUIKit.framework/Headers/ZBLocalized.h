//
//  ZBLocalized.h
//  ZBKit
//
//  Created by NQ UEC on 2017/5/12.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LanguageType) {
    kLanguageTypeEn = 1,// 1
    kLanguageTypeZhHans, // 2
    kLanguageVi, // 3
};
typedef void(^ChangeLanguageComplate)(void);
//语言切换
static NSString * const kAppLanguage = @"appLanguage";

@interface ZBLocalized : NSObject

+ (ZBLocalized *)sharedInstance;

//初始化多语言功能
- (void)initLanguage;

//当前语言
- (NSString *)currentLanguage;

- (NSString *)currentLanguageDesc;

- (NSInteger)currentLanguareType;

//设置要转换的语言
- (BOOL)setLanguage:(LanguageType)language;

//设置为系统语言
- (void)systemLanguage;

+ (NSString *)localized:(NSString *)key table:(NSString *)table;


@end
