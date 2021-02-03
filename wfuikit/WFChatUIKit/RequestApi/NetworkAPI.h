//
//  NetworkAPI.h
//  WildFireChat
//
//    on 2019/11/14.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "APIUrl.h"
#import "ToastManager.h"
#import "ZBLocalized.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SuccessBLock)(NSDictionary *done);
typedef void(^FailureBLock)(NSDictionary *done);

@interface NetworkAPI : NSObject

/**
 返回网络请求单例
 @return 网络请求单例
 */
+ (instancetype)sharedInstance;

/**
 SHA1 加密后的字符串
 @param str 加密前的字符串
 @return 返回加密后的字符串
 */
+ (NSString *)sha1:(NSString *)str;

/**
 POST 网络请求方式
 @param url 请求地址
 @param param 请求参数
 @param success 请求成功状态码200的回调---后台请求可能为请求失败，但是失败的处理也在成功的回调中进行
 @param failure 请求失败回调状态码为非200的回调---请求失败的回调，为网络状态码部位200的错误
 */
- (void)postWithUrl:(NSString *)url params:(NSDictionary *) param successComplection: (SuccessBLock )success  failureComplection: (FailureBLock)failure;

/**
 GET 网络请求方式
 @param url 请求地址
 @param param 参数
 @param success 网络状态码为 200的回调
 @param failure 网络状态码为 非200的回调
 */
- (void)getWithUrl:(NSString *)url params:(NSDictionary *) param successComplection: (SuccessBLock )success  failureComplection: (FailureBLock)failure;

- (void)v2GetWithUrl:(NSString *)url successComplection: (SuccessBLock )success  failureComplection: (FailureBLock)failure;
- (void)v2GetWithUrl:(NSString *)url params:(NSDictionary *) param successComplection: (SuccessBLock )success  failureComplection: (FailureBLock)failure;

- (void)v2POST:(NSString *)URLString
        params:(id)params
constructingBodyWithBlock:(NSData *)data
      progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
       success:(SuccessBLock)success
       failure:(FailureBLock)failure;

@end

NS_ASSUME_NONNULL_END
