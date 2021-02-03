//
//  CompressVideoManager.h
//  WFChatUIKit
//
//  Created by xxxty on 2018/3/8.
//  Copyright © 2018 Tom Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "ZBLocalized.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompressVideoManager : NSObject

//- (void)export:(AVAsset *)asset success:(void(^)(NSString *path))completed;
- (void)export:(AVURLAsset *)asset outFilePath:(NSString *)outPutPath success:(void (^)(NSString * _Nonnull))completed;
- (void)compressVideoWiithAsset:(AVURLAsset *)asset withVideoSize:(CGSize)size outPutFile:(NSString *)outPath complection:(void (^)(NSString * _Nonnull))completed;
@end

NS_ASSUME_NONNULL_END
