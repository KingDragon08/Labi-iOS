//
//  WFCCUtilities.h
//  WFChatClient
//
//  Created by heavyrain on 2017/9/7.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Is_iPhoneX ([UIScreen mainScreen].bounds.size.height == 812.0f ||[UIScreen mainScreen].bounds.size.height == 896.0f )

#define kSafeBarHeight (Is_iPhoneX ? 88.f : 64.f)

@interface WFCCUtilities : NSObject

/**
 生成缩略图

 @param image 原图
 @param targetWidth 宽度
 @param targetHeight 高度
 @return 缩略图
 */
+ (UIImage *)generateThumbnail:(UIImage *)image
                     withWidth:(CGFloat)targetWidth
                    withHeight:(CGFloat)targetHeight;


/**
 获取对应的沙盒路径

 @param localPath 文件路径
 @return 对应的沙盒路径
 */
+ (NSString *)getSendBoxFilePath:(NSString *)localPath;

/**
 获取资源路径

 @param componentPath 相对路径
 @return 资源路径
 */
+ (NSString *)getDocumentPathWithComponent:(NSString *)componentPath;

+ (CGSize)imageScaleSize:(CGSize)imageSize targetSize:(CGSize)targetSize thumbnailPoint:(CGPoint *)thumbnailPoint;


+ (CGFloat) onepxLine;
+ (UIColor *) wechatGreenColor;
+ (UIColor *) timeLineColor;
+ (UIColor *) titleColor;
+ (UIColor *) onePxLineColor;
+ (UIColor *) backgoundColor;
+ (UIColor *) grayTextColor;
+ (UIColor *) toolBarBagColor;
@end
