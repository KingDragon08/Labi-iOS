//
//  Utilities.h
//  WFChat UIKit
//
//  Created by WF Chat on 2017/9/1.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WFChatClient/WFCChatClient.h>
#import "ZBLocalized.h"

@interface WFCUUtilities : NSObject
+ (CGSize)getTextDrawingSize:(NSString *)text
                        font:(UIFont *)font
             constrainedSize:(CGSize)constrainedSize;
+ (NSString *)formatTimeLabel:(int64_t)timestamp;
+ (NSString *)formatTimeDetailLabel:(int64_t)timestamp;
+ (UIImage *)thumbnailWithImage:(UIImage *)originalImage maxSize:(CGSize)size;

/**
 NSDictionary 转为json
 @param dic 需要转为json的字段
 @return 返回json
 */
+ (NSString *)jsonWithDic:(NSDictionary *)dic;

/**
 字符串转为字典
 @param jsonString 需要转为你字典的字符串
 @return 返回NSDictionary
 */
+ (NSDictionary *)dicWithJson:(NSString *)jsonString;

+ (BOOL)stringIsNull:(NSString *)str;
@end
