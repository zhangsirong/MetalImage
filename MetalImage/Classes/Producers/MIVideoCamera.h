//
//  MIVideoCamera.h
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIVideoCaptor.h"

@class MIVideoCamera;

@protocol MIVideoCameraDelegate <NSObject, MIVideoCaptorDelegate>

@optional

//需要shouldRecordAudio设置为yes才有回调
- (void)videoCamera:(MIVideoCamera *)videoCamera didReceiveAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end

@interface MIVideoCamera : MIVideoCaptor<AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic, weak) id<MIVideoCameraDelegate> delegate;


@property (nonatomic, readonly) BOOL hasFlash;
@property (nonatomic, readonly) NSDictionary *recommendedAudioSettings;

@property (nonatomic, assign) AVCaptureFlashMode flashMode;

/** 是否需要录制音量 默认NO  */
@property (nonatomic, getter=isAudioEnabled) BOOL audioEnabled;

/** 是否需要拍照功能 默认NO  */
@property (nonatomic, getter=isPhotoCaptureEnabled) BOOL photoCaptureEnabled;


//需要photoCaptureEnabled设置为yes才有作用
- (void)captureImageSampleBufferAsynchronouslyWithCompletionHandler:(void (^)(CMSampleBufferRef imageSampleBuffer, NSError *error))handler;

- (void)captureOriginalImageAsynchronouslyWithCompletionHandler:(void (^)(UIImage *originalImage, NSError *error))handler;

@end
