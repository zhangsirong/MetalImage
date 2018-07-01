//
//  MIVideo.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIProducer.h"
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, MIVideoStatus) {
    MIVideoStatusWaiting,
    MIVideoStatusPlaying,
    MIVideoStatusPaused,
};

typedef NS_ENUM(NSUInteger, MIVideoOrientation) {
    MIVideoOrientationUnknown            ,
    MIVideoOrientationPortrait           ,
    MIVideoOrientationPortraitUpsideDown ,
    MIVideoOrientationLandscapeLeft      ,
    MIVideoOrientationLandscapeRight
};

@class MIVideo;

@protocol MIVideoDelegate <NSObject>

@optional
- (void)video:(MIVideo *)video willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (void)videoDidEnd:(MIVideo *)video;

@end


@interface MIVideo : MIProducer

@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) NSURL *url;

@property (nonatomic, readonly) MIVideoStatus status;
@property (nonatomic) double progress;
@property (nonatomic, readonly) CGSize size;
@property (nonatomic) MIVideoOrientation orientation;

@property (nonatomic, readonly) double duration; //返回视频的总长度，单位为秒。
@property (nonatomic, readonly) float frameRate;
@property (nonatomic, assign) BOOL playAtActualSpeed;  //是否需要正常速度处理，默认YES

@property (nonatomic, weak) id<MIVideoDelegate> delegate;


- (instancetype)initWithAsset:(AVAsset *)asset;
- (instancetype)initWithURL:(NSURL *)url;

- (BOOL)play;
- (void)stop;
- (void)pause;

- (CMSampleBufferRef)copyNextAudioSampleBuffer;

@end
