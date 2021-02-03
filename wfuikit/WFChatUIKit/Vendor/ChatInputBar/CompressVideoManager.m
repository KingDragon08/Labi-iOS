//
//  CompressVideoManager.m
//  WFChatUIKit
//
//  Created by xxxty on 2018/3/8.
//  Copyright © 2018 Tom Lee. All rights reserved.
//

#import "CompressVideoManager.h"
#import "WAVideoBox.h"

@interface CompressVideoManager () {
    WAVideoBox *videoBox;
}

@end

@implementation CompressVideoManager

-(void)dealloc {
     NSLog(@"CompressVideoManager dealloc_______");
}

- (CGSize)settingCompressSize:(CGSize)oSize {
    if (oSize.width > 1080 || oSize.height > 1080) {
        if (oSize.width > oSize.height){
            CGFloat mWidth = oSize.width;
            oSize.width = 1080;
            oSize.height = 1080/ mWidth * oSize.height;
        } else {
            CGFloat mHeight = oSize.height;
            oSize.height = 1080;
            oSize.width = 1080 / mHeight * (oSize.width);
        }
    }
    return oSize;
}

- (void)compressVideoWiithAsset:(AVURLAsset *)asset withVideoSize:(CGSize)size outPutFile:(NSString *)outPath complection:(void (^)(NSString * _Nonnull))completed{
    /// 码率 = 视频文件大小/视频时长
    NSInteger compressBitRate = 1500 * 1024;
    /// 帧率 = 每秒钟的画面个数
    NSInteger compressFrameRate = 30;
    /// 分辨率
    
//    最大 1080 * 1080
    CGSize compressSize =  [self settingCompressSize:size];
    NSInteger compressWidth = compressSize.width;
    NSInteger compressHeight = compressSize.height;
    /// 视频的时长
    CMTime time = [asset duration];
    
    
    AVAssetTrack *videoTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
     AVAssetReaderTrackOutput *videoOutPut = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:videoTrack  outputSettings:[CompressVideoManager configVideoOutput]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"urlStr" : asset.URL.path}];
    
    AVAssetTrack *audioTrack = [asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
    AVAssetReaderTrackOutput *audioOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:audioTrack outputSettings:[CompressVideoManager configAudioOutput]];
    
    /// 创建文件读取着
    AVAssetReader *reader = [AVAssetReader assetReaderWithAsset:asset error:nil];
   
    if ([reader canAddOutput:videoOutPut]) {
        [reader addOutput:videoOutPut];
    }
    
    if ([reader canAddOutput:audioOutput]) {
        [reader addOutput:audioOutput];
    }
    
    /// 视频文件写入着
    AVAssetWriter *writer = [AVAssetWriter assetWriterWithURL:[NSURL fileURLWithPath:outPath] fileType:AVFileTypeMPEG4 error:nil];
    
    AVAssetWriterInput *videoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:[CompressVideoManager videoCompressSettingsWithBitRate:compressBitRate withFrameRate:compressFrameRate withWidth:compressSize.width WithHeight:compressSize.height withOriginalWidth:compressSize.width withOriginalHeight:compressSize.height]];
    
    AVAssetWriterInput *audioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:[CompressVideoManager audioCompressSettings]];
    
    if ([writer canAddInput:videoInput]) {
        [writer addInput:videoInput];
    }
    
    if ([writer canAddInput:audioInput]) {
        [writer addInput:audioInput];
    }
//    dispatch_queue_t videoQueue = dispatch_queue_create("Video Queue", DISPATCH_QUEUE_SERIAL);
       //创建音频写入队列
//       dispatch_queue_t audioQueue = dispatch_queue_create("Audio Queue", DISPATCH_QUEUE_SERIAL);
    [reader startReading];
    [writer startWriting];
    [writer startSessionAtSourceTime:kCMTimeZero];
    dispatch_queue_t videoQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_group_async(group, videoQueue, ^{
        [videoInput requestMediaDataWhenReadyOnQueue:videoQueue usingBlock:^{
            BOOL completedOrFailed = NO;
            while ([videoInput isReadyForMoreMediaData] && !completedOrFailed) {
                CMSampleBufferRef sampleBuffer = [videoOutPut copyNextSampleBuffer];
                if (sampleBuffer != NULL) {
                    [videoInput appendSampleBuffer:sampleBuffer];
                    NSLog(@"===%@===", sampleBuffer);
                    CFRelease(sampleBuffer);
                } else {
                    completedOrFailed = YES;
                    [videoInput markAsFinished];
                    dispatch_group_leave(group);
                }
            }
        }];
    });
    
    
    
    dispatch_group_enter(group);
    dispatch_group_async(group, videoQueue, ^{
        [audioInput requestMediaDataWhenReadyOnQueue:videoQueue usingBlock:^{
            BOOL completedOrFailed = NO;
            while ([audioInput isReadyForMoreMediaData] && !completedOrFailed) {
                CMSampleBufferRef sampleBuffer = [videoOutPut copyNextSampleBuffer];
                if (sampleBuffer != NULL) {
                    BOOL success = [audioInput appendSampleBuffer:sampleBuffer];
                    NSLog(@"===%@===", sampleBuffer);
                    CFRelease(sampleBuffer);
                    completedOrFailed = !success;
                } else {
                    completedOrFailed = YES;
                }
            }
            if (completedOrFailed) {
                [audioInput markAsFinished];
                dispatch_group_leave(group);
            }
        }];
    });
//    dispatch_queue_t audioQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if ([reader status] == AVAssetReaderStatusReading) {
            [reader cancelReading];
        }
        switch (writer.status) {
            case AVAssetWriterStatusWriting:
            {
                [writer finishWritingWithCompletionHandler:^{
//                    completed(outPath);
//                    [dic setObject:outputUrlStr forKey:@"urlStr"];
                }];
            }
                break;
            case AVAssetWriterStatusCancelled:
                break;
            case AVAssetWriterStatusFailed:
                NSLog(@"===error：%@===", writer.error);
                break;
            case AVAssetWriterStatusCompleted:
            {
                [writer finishWritingWithCompletionHandler:^{
//                    [dic setObject:outputUrlStr forKey:@"urlStr"];
                    completed(outPath);
                }];
            }
                break;
            default:
                break;
        }
    });
}

/** 视频解码 */
+ (NSDictionary *)configVideoOutput
{
    NSDictionary *videoOutputSetting = @{
                                         (__bridge NSString *)kCVPixelBufferPixelFormatTypeKey:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_422YpCbCr8],
                                         (__bridge NSString *)kCVPixelBufferIOSurfacePropertiesKey:[NSDictionary dictionary]
                                         };
    
    return videoOutputSetting;
}

/** 音频解码 */
+ (NSDictionary *)configAudioOutput
{
    NSDictionary *audioOutputSetting = @{
                                         AVFormatIDKey: @(kAudioFormatLinearPCM)
                                         };
    return audioOutputSetting;
}

+ (NSDictionary *)videoCompressSettingsWithBitRate:(NSInteger)biteRate withFrameRate:(NSInteger)frameRate withWidth:(NSInteger)width WithHeight:(NSInteger)height withOriginalWidth:(NSInteger)originalWidth withOriginalHeight:(NSInteger)originalHeight{
    /*
     * AVVideoAverageBitRateKey： 比特率（码率）每秒传输的文件大小 kbps
     * AVVideoExpectedSourceFrameRateKey：帧率 每秒播放的帧数
     * AVVideoProfileLevelKey：画质水平
     BP-Baseline Profile：基本画质。支持I/P 帧，只支持无交错（Progressive）和CAVLC；
     EP-Extended profile：进阶画质。支持I/P/B/SP/SI 帧，只支持无交错（Progressive）和CAVLC；
     MP-Main profile：主流画质。提供I/P/B 帧，支持无交错（Progressive）和交错（Interlaced），也支持CAVLC 和CABAC 的支持；
     HP-High profile：高级画质。在main Profile 的基础上增加了8×8内部预测、自定义量化、 无损视频编码和更多的YUV 格式；
     **/
    NSInteger returnWidth = originalWidth > originalHeight ? width : height;
    NSInteger returnHeight = originalWidth > originalHeight ? height : width;
    
    NSDictionary *compressProperties = @{
                                         AVVideoAverageBitRateKey : @(biteRate),
                                         AVVideoExpectedSourceFrameRateKey : @(frameRate),
                                         AVVideoProfileLevelKey : AVVideoProfileLevelH264HighAutoLevel
                                         };
    if (@available(iOS 11.0, *)) {
        NSDictionary *compressSetting = @{
                                          AVVideoCodecKey : AVVideoCodecTypeH264,
                                          AVVideoWidthKey : @(returnWidth),
                                          AVVideoHeightKey : @(returnHeight),
                                          AVVideoCompressionPropertiesKey : compressProperties,
                                          AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill
                                          };
        return compressSetting;
    }else {
        NSDictionary *compressSetting = @{
                                          AVVideoCodecKey : AVVideoCodecTypeH264,
                                          AVVideoWidthKey : @(returnWidth),
                                          AVVideoHeightKey : @(returnHeight),
                                          AVVideoCompressionPropertiesKey : compressProperties,
                                          AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill
                                          };
        return compressSetting;
    }
}

//音频设置
+ (NSDictionary *)audioCompressSettings{
    AudioChannelLayout stereoChannelLayout = {
        .mChannelLayoutTag = kAudioChannelLayoutTag_Stereo,
        .mChannelBitmap = kAudioChannelBit_Left,
        .mNumberChannelDescriptions = 0,
    };
    NSData *channelLayoutAsData = [NSData dataWithBytes:&stereoChannelLayout length:offsetof(AudioChannelLayout, mChannelDescriptions)];
    NSDictionary *audioCompressSettings = @{
                                            AVFormatIDKey : @(kAudioFormatMPEG4AAC),
                                            AVEncoderBitRateKey : @(128000),
                                            AVSampleRateKey : @(44100),
                                            AVNumberOfChannelsKey : @(2),
                                            AVChannelLayoutKey : channelLayoutAsData
                                            };
    return audioCompressSettings;
}

- (void)export:(AVURLAsset *)asset outFilePath:(NSString *)outPutPath success:(void (^)(NSString * _Nonnull))completed {
    NSString *filePath = asset.URL.absoluteString;
    /// 视频轨道
    AVAssetTrack *videoTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    /// 获取视频大小
    unsigned long long fileSIze = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil].fileSize;
    /// 计算视频大小
    float fileSizeMB = fileSIze / (1024 * 1024);
    /// 获取视频宽高
    NSInteger videoWidth = videoTrack.naturalSize.width;
    /// 视频高度
    NSInteger videoHeight = videoTrack.naturalSize.height;
    /// 比特率
    NSInteger kbps = videoTrack.estimatedDataRate / 1024;
    ///帧率
    NSInteger frameRate = [videoTrack nominalFrameRate];
    
    
    
    
    /// 音频轨道
    AVAssetTrack *audioTrack = [asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
    
}

//- (void)export:(AVAsset *)asset outFilePath:(NSString *)outPutPath success:(void (^)(NSString * _Nonnull))completed {
//    NSError *error;
//    AVAssetReader *reader = [AVAssetReader assetReaderWithAsset:asset error:nil];
//    AVFileType aFileType = AVFileTypeMPEG4;
//    AVAssetWriter *writer = [AVAssetWriter assetWriterWithURL:[NSURL fileURLWithPath:outPutPath] fileType:aFileType error:nil];
//
//    // video part
//    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
//    AVAssetReaderTrackOutput *videoOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:videoTrack outputSettings:nil];
//    AVAssetWriterInput *videoInout = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:[self videoCompressSetting]];
//
//
//
//    if ([reader canAddOutput:videoOutput]) {
//        [reader addOutput:videoOutput];
//    }
//
//    if ([writer canAddInput:videoInout]) {
//        [writer addInput:videoInout];
//    }
//
//    AVAssetTrack *audioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
//    AVAssetReaderTrackOutput *audioOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:audioTrack outputSettings:nil];
//
//    AVAssetWriterInput *audioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:[self audioCompressSettings]];
//    if ([reader canAddOutput:audioOutput]) {
//        [reader addOutput:audioOutput];
//    }
//    if ([writer canAddInput:audioInput]) {
//        [writer addInput:audioInput];
//    }
//
//    [reader startReading];
//    [writer startWriting];
//    [writer startSessionAtSourceTime:kCMTimeZero];
//
//    dispatch_group_t aGroup = dispatch_group_create();
//    dispatch_queue_t videoQueue = dispatch_queue_create("com.video.queue", DISPATCH_QUEUE_SERIAL);
//    dispatch_group_enter(aGroup);
//
//    [videoInout requestMediaDataWhenReadyOnQueue:videoQueue usingBlock:^{
//        while ([videoInout isReadyForMoreMediaData]) {
//            CMSampleBufferRef sampleBufferRef;
//            if ([reader status] == AVAssetReaderStatusReading && (sampleBufferRef = [videoOutput copyNextSampleBuffer])) {
//                BOOL result = [videoInout appendSampleBuffer:sampleBufferRef];
//                CFRelease(sampleBufferRef);
//                if (!result) {
//                    [reader cancelReading];
//                    break;
//                }
//            } else {
//                [videoInout markAsFinished];
//                dispatch_group_leave(aGroup);
//            }
//        }
//    }];
//
//    dispatch_group_enter(aGroup);
//    [audioInput requestMediaDataWhenReadyOnQueue:videoQueue usingBlock:^{
//        while ([audioInput isReadyForMoreMediaData]) {
//            CMSampleBufferRef sampleBufferRef;
//            if ([reader status] == AVAssetReaderStatusReading && (sampleBufferRef = [audioOutput copyNextSampleBuffer])) {
//                BOOL result = [audioInput appendSampleBuffer:sampleBufferRef];
//                CFRelease(sampleBufferRef);
//                if (!result) {
//                    [reader cancelReading];
//                    break;
//                }
//            } else {
//                [audioInput markAsFinished];
//                dispatch_group_leave(aGroup);
//            }
//        }
//    }];
//
//    dispatch_group_notify(aGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        if ([reader status] == AVAssetReaderStatusReading) {
//            [reader cancelReading];
//        }
//        switch (writer.status) {
//            case AVAssetWriterStatusWriting: {
//                NSLog(@"Compress done __________");
//            }
//                break;
//
//            default:
//                break;
//        }
//    });
//
//}
//
//- (NSDictionary *) videoOutPutSettings {
//    return @{};
//}
//
//- (NSDictionary *) videoCompressSetting {
//    NSDictionary *properties = @ {
//        AVVideoAverageBitRateKey : @(200 *8 * 1024),
//        AVVideoExpectedSourceFrameRateKey : @30,
//        AVVideoProfileLevelKey : AVVideoProfileLevelH264HighAutoLevel };
//    NSDictionary *videoCompressDic = @ {
//        AVVideoCodecKey : AVVideoCodecTypeH264,
//        AVVideoWidthKey : @960,
//        AVVideoHeightKey : @540,
//        AVVideoCompressionPropertiesKey : properties,
//        AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill };
//    return videoCompressDic;
//}
//
//- (NSDictionary *) audioCompressSettings {
//    AudioChannelLayout layout = {
//        .mChannelLayoutTag = kAudioChannelLayoutTag_Stereo,
//        .mChannelBitmap = 0,
//        .mNumberChannelDescriptions = 0 };
//    NSData *layoutData = [NSData dataWithBytes:&layout length:offsetof(AudioChannelLayout, mChannelDescriptions[1])];
//    NSDictionary *audioCompressSetting = @{
//        AVFormatIDKey : @(kAudioFormatMPEG4AAC),
//        AVEncoderBitRateKey : @96000,
//        AVSampleRateKey : @44100,
//        AVChannelLayoutKey : layoutData,
//        AVNumberOfChannelsKey : @2};
//    return audioCompressSetting;
//
//}

@end
