//
//  MIAudioVideoWriter.h
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MIConsumer.h"

typedef enum : NSUInteger {
    MIAudioVideoWriterStatusWaiting   = 0,
    MIAudioVideoWriterStatusWriting   = 1,
    MIAudioVideoWriterStatusCompleted = 2,
    MIAudioVideoWriterStatusFailed    = 3,
    MIAudioVideoWriterStatusCancelled = 4
} MIAudioVideoWriterStatus;


@class MIAudioVideoWriter;

@protocol MIAudioVideoWriterDelegate <NSObject>

@optional

- (void)audioVideoWriterRequestNextAudioSampleBuffer:(MIAudioVideoWriter *)audioVideoWriter;
- (void)audioVideoWriterDidfinishWriting:(MIAudioVideoWriter *)audioVideoWriter;
- (void)audioVideoWriter:(MIAudioVideoWriter *)audioVideoWriter isWritingAtTime:(CMTime)frameTime;

@end


@interface MIAudioVideoWriter : NSObject <MIConsumer>

@property (nonatomic, getter=isEnabled) BOOL enabled;
@property (nonatomic) CGSize contentSize;
@property (nonatomic) NSURL *outputURL;
@property (nonatomic) BOOL shouldWriteWithAudio;
@property (nonatomic) NSDictionary *compressionAudioSettings;
@property (nonatomic, getter=isWritingInRealTime) BOOL writingInRealTime;

@property (nonatomic, strong) NSDictionary *videoOutputSettings;

@property (nonatomic, weak) id<MIAudioVideoWriterDelegate> delegate;

@property (nonatomic, readonly) MIAudioVideoWriterStatus status;

- (instancetype)initWithOutputURL:(NSURL *)outputURL;

- (instancetype)initWithContentSize:(CGSize)contentSize outputURL:(NSURL *)outputURL;
- (instancetype)initWithContentSize:(CGSize)contentSize outputURL:(NSURL *)outputURL fileType:(NSString *)outputFileType settings:(NSDictionary *)outputSettings;

- (void)finishWriting;

- (void)writeWithAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;


@end
