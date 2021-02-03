//
//  ZBLocalized.m
//  ZBKit
//
//  Created by NQ UEC on 2017/5/12.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBLocalized.h"

@interface ZBLocalized() {
    NSDictionary *_maps;
    NSDictionary *_values;
}

@end
@implementation ZBLocalized
+ (ZBLocalized *)sharedInstance{
    static ZBLocalized *language=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        language = [[ZBLocalized alloc] init];
    });
    return language;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _maps = @{
            @1:@"en",
            @2:@"zh-Hans",
            @3:@"vi"
        };
        
        _values = @{
            @"en":@"English",
            @"zh-Hans":@"简体中文",
            @"vi":@"ViệtName"
        };
    }
    return self;
}

- (void)initLanguage{
    NSString *language = [self currentLanguage];
    if (language.length>0) {
        NSLog(@"自设置语言:%@",language);
    }else{
        [self systemLanguage];
    }
}

- (NSInteger)currentLanguareType {
    return [[_values valueForKey:[self currentLanguage]] integerValue];
}

- (NSString *)currentLanguageDesc {
    NSString *key = [self currentLanguage];
    NSString *result = @"";
    @try {
        result = [_values valueForKey:key];
    } @catch (NSException *exception) {
    }
    return result;
}

- (NSString *)currentLanguage{
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:kAppLanguage];
    return language;
}


- (BOOL)setLanguage:(LanguageType)language {
    if ([self.currentLanguage isEqualToString:[self languageFromType:language]]) {
        return NO;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[self languageFromType:language] forKey:kAppLanguage];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

- (NSString *)languageFromType:(LanguageType)type {
    switch (type) {
        case kLanguageTypeEn:
            return @"en";
        case kLanguageTypeZhHans:
            return @"zh-Hans";
        case kLanguageVi:
            return @"vi";
        default:
            break;
    }
    return [self currentLanguage];
}

- (void)systemLanguage{
    NSString *languageCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0];
    NSLog(@"系统语言:%@",languageCode);
    if([languageCode hasPrefix:@"zh-Hant"]){
        languageCode = @"zh-Hant";//繁体中文
    }else if([languageCode hasPrefix:@"zh-Hans"]){
        languageCode = @"zh-Hans";//简体中文
    }else if([languageCode hasPrefix:@"pt"]){
        languageCode = @"pt";//葡萄牙语
    }else if([languageCode hasPrefix:@"es"]){
        languageCode = @"es";//西班牙语
    }else if([languageCode hasPrefix:@"th"]){
        languageCode = @"th";//泰语
    }else if([languageCode hasPrefix:@"hi"]){
        languageCode = @"hi";//印地语
    }else if([languageCode hasPrefix:@"ru"]){
        languageCode = @"ru";//俄语
    }else if([languageCode hasPrefix:@"ja"]){
        languageCode = @"ja";//日语
    }else if([languageCode hasPrefix:@"en"]){
        languageCode = @"en";//英语
    }else{
        languageCode = @"en";//英语
    }
    [[NSUserDefaults standardUserDefaults] setObject:languageCode forKey:kAppLanguage];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)localized:(NSString *)key table:(NSString *)table {
    return [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:kAppLanguage]] ofType:@"lproj"]] localizedStringForKey:(key) value:@"" table:table];
}

@end
