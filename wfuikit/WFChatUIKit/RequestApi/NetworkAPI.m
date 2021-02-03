//
//  NetworkAPI.m
//  WildFireChat
//
//    on 2019/11/14.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import "NetworkAPI.h"
#import "MBProgressHUD.h"
#import "WFCConfig.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworking.h"

@interface NetworkAPI ()

@property (nonatomic) AFHTTPSessionManager *sessionManager;
@property (nonatomic) AFHTTPSessionManager *v2SessionManager;

@end

@implementation NetworkAPI

@synthesize sessionManager;
@synthesize v2SessionManager;

+ (instancetype)sharedInstance
{
    static NetworkAPI *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [instance initSessionManager];
    });
    return instance;
}

- (void)initSessionManager
{
    NSURLSessionConfiguration *configation = [NSURLSessionConfiguration defaultSessionConfiguration];
    configation.timeoutIntervalForRequest = 30;
    sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:APP_SERVER_ADDRESS] sessionConfiguration:configation];
    sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [sessionManager.requestSerializer setValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [self initNewSessionManager];
}

- (void)initNewSessionManager {
    NSURLSessionConfiguration *configation = [NSURLSessionConfiguration defaultSessionConfiguration];
    configation.timeoutIntervalForRequest = 30;
    v2SessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:GAME_SERVER_ADDRESS] sessionConfiguration:configation];
    v2SessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    v2SessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    v2SessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [v2SessionManager.requestSerializer setValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    v2SessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
}

- (void)setRequestHeader {
    NSString *nonce = [NSString stringWithFormat:@"%u", arc4random_uniform(100000)];
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970];// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", time];
    NSString *key = APP_SERVER_KEY;
    NSString *sign = [NSString stringWithFormat:@"%@|%@|%@",nonce,timestamp,key];
    NSString *sha1 = [NetworkAPI sha1:sign];
    
    [sessionManager.requestSerializer setValue:nonce forHTTPHeaderField: @"nonce"];
    [sessionManager.requestSerializer setValue:timestamp forHTTPHeaderField:@"timestamp"];
    [sessionManager.requestSerializer setValue:sha1 forHTTPHeaderField:@"sign"];
}

- (void)v2SetRequestHeader {
    NSString *salt = @"rr9OOYSciZh+LiA";
    NSString *rand = [NSString stringWithFormat:@"%u", arc4random_uniform(100000)];

    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970];// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", time];
    double v = [rand doubleValue] + time;
    NSString * vs = [NSString stringWithFormat:@"%.0f", v];
    NSString *s = [NSString stringWithFormat:@"%@%@%@",salt,vs,rand];
    NSString *sha1 = [NetworkAPI md5:s];
    [v2SessionManager.requestSerializer setValue:s forHTTPHeaderField: @"x-xxxx"];
    [v2SessionManager.requestSerializer setValue:timestamp forHTTPHeaderField: @"x-timestamp"];
    [v2SessionManager.requestSerializer setValue:rand forHTTPHeaderField:@"x-rand"];
    [v2SessionManager.requestSerializer setValue:sha1 forHTTPHeaderField:@"x-token"];
}

- (void)v2GetWithUrl:(NSString *)url successComplection:(SuccessBLock)success failureComplection:(FailureBLock)failure {
    [self v2GetWithUrl:url params:nil successComplection:success failureComplection:failure];
}

- (void)v2POST:(NSString *)URLString
        params:(id)params
constructingBodyWithBlock:(NSData *)data
      progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
       success:(SuccessBLock)success
       failure:(FailureBLock)failure {
    [self v2SetRequestHeader];
    [v2SessionManager POST:URLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:data name:@"formaData"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ToastManager hiddenHud];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *status = [NSString stringWithFormat:@"%@", dict[@"status"]];
        if (status.intValue == 0) {
            success(dict);
        } else {
            failure(dict);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ToastManager hiddenHud];
        NSDictionary *dic = @{@"msg": error.description};
        failure(dic);
    }];
}

- (void)v2GetWithUrl:(NSString *)url params:(NSDictionary *)param successComplection:(SuccessBLock)success failureComplection:(FailureBLock)failure {
    [self v2SetRequestHeader];
    [v2SessionManager GET:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ToastManager hiddenHud];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *status = [NSString stringWithFormat:@"%@", dict[@"status"]];
        if (status.intValue == 0) {
            success(dict);
        } else {
            failure(dict);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ToastManager hiddenHud];
        NSDictionary *dic = @{@"msg": error.description};
        failure(dic);
    }];
}

- (void)postWithUrl:(NSString *)url params:(NSDictionary *) param successComplection: (SuccessBLock )success  failureComplection: (FailureBLock)failure {
    [self setRequestHeader];
    NSString *params = [self wholeParam:param];
    [sessionManager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ToastManager hiddenHud];
        NSLog(@"%@",responseObject);
        NSDictionary *dict = responseObject;
        NSString *status = [NSString stringWithFormat:@"%@", dict[@"status"]];
        if (status.intValue == 0) {
            success(dict);
        } else {
            failure(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ToastManager hiddenHud];
        NSDictionary *dic = @{@"msg": error.description};
        failure(dic);
    }];
}

- (NSURLSessionDataTask *)getWithUrl:(NSString *)url params:(NSDictionary *) param successComplection: (SuccessBLock )success  failureComplection: (FailureBLock)failure {
    [self setRequestHeader];
    return [sessionManager GET:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ToastManager hiddenHud];
        NSDictionary *dict = responseObject;
        NSString *status = [NSString stringWithFormat:@"%@", dict[@"status"]];
        if (status.intValue == 0) {
            success(dict);
        } else {
            failure(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ToastManager hiddenHud];
        NSString *str = [NSString stringWithFormat:@"%@", error.description];
        NSDictionary *dic = @{@"msg": str};
        failure(dic);
    }];
}

- (NSString *)wholeParam: (NSDictionary *)dic {
    NSString *str = @"";
    for (NSString * key in dic) {
        str = [NSString stringWithFormat:@"%@%@=%@&",str,key,dic[key]];
    }
    if ([str isEqualToString:@""] == false) {
        str = [str substringToIndex:str.length - 1];
    }
    return str;
}

+ (NSString *)sha1:(NSString *)str {
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

+ (NSString *)md5:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    return result.lowercaseString;
}


@end
