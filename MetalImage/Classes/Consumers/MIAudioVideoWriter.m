//
//  MIAudioVideoWriter.m
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIAudioVideoWriter.h"
#import "MITexture.h"
#import "MIContext.h"

@interface MIAudioVideoWriter ()
{
    NSString *_fileType;
    AVAssetWriter *_assetWriter;
    AVAssetWriterInput *_assetWriterAudioInput;
    AVAssetWriterInput *_assetWriterVideoInput;
    AVAssetWriterInputPixelBufferAdaptor *_assetWriterInputPixelBufferAdaptor;
    
    NSMutableDictionary *_outputSettings;
    CVPixelBufferRef _wrotePixelBuffer;
    
    MITexture *_inputTexture;
    
    NSDictionary *_compressionAudioSettings;
    
    CMTime _frameTime;
    CMTime _preFrameTime;
    NSTimeInterval _previousFrameActualTime;
    
    BOOL _audioWritingCompleted;
    
    CMTime _lastAudioBufferTimeStamp;
    CMTime _startTime;
    
    int _frameRate;
    
    MITexture *_writerTexture;
    
    id<MTLRenderPipelineState> _renderPipelineState;
    MTLRenderPassDescriptor *_passDescriptor;
    
    id<MTLBuffer> _positionBuffer;
    CGRect _preRenderRect;
}

@property  (nonatomic) MIAudioVideoWriterStatus status;

@end


@implementation MIAudioVideoWriter

- (void)dealloc {
    if (_wrotePixelBuffer) {
        CVPixelBufferRelease(_wrotePixelBuffer);
    }
}

- (instancetype)initWithOutputURL:(NSURL *)outputURL {
    self = [self initWithContentSize:CGSizeZero outputURL:outputURL];
    return self;
}

- (instancetype)initWithContentSize:(CGSize)contentSize outputURL:(NSURL *)outputURL {
    self = [self initWithContentSize:contentSize outputURL:outputURL fileType:AVFileTypeQuickTimeMovie settings:nil];
    return self;
}

- (instancetype)initWithContentSize:(CGSize)contentSize outputURL:(NSURL *)outputURL fileType:(NSString *)outputFileType settings:(NSDictionary *)outputSettings {
    if (self = [super init]) {
        self.enabled = NO;
        self.outputURL = outputURL;
        _contentSize = contentSize;

        _fileType = [outputFileType copy];
        _startTime = kCMTimeZero;
        
        if (outputSettings) {
            _outputSettings = [[NSMutableDictionary alloc] initWithDictionary:outputSettings];
        }
        
        _writerTexture = [[MITexture alloc] init];
        _renderPipelineState = [MIContext createRenderPipelineStateWithVertexFunction:@"MIDefaultVertexShader"
                                                                     fragmentFunction:@"MIDefaultFragmentShader"];
        _passDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
        
    }
    return self;
}


- (void)setInputTexture:(MITexture *)inputTexture {
    if (_inputTexture != inputTexture) {
        _inputTexture = nil;
        _inputTexture = inputTexture;
    }
}

- (void)setShouldWriteWithAudio:(BOOL)shouldWriteWithAudio {
    if (self.status != MIAudioVideoWriterStatusWaiting) {
        return;
    }
    _shouldWriteWithAudio = shouldWriteWithAudio;
}

- (void)setVideoOutputSettings:(NSDictionary *)videoOutputSettings {
    _outputSettings = [[NSMutableDictionary alloc] initWithDictionary:videoOutputSettings];
}

- (void)renderRect:(CGRect)rect atTime:(CMTime)time commandBuffer:(id<MTLCommandBuffer>)commandBuffer {
    if (!_inputTexture || !self.isEnabled || self.status == MIAudioVideoWriterStatusCompleted) {
        return;
    }
    
    if (CGSizeEqualToSize(self.contentSize, CGSizeZero)) {
        self.contentSize = _inputTexture.size;
    }
    
    if (self.status == MIAudioVideoWriterStatusWaiting) {
        [self startWriting];
        BOOL startingSuccess = [_assetWriter startWriting];
        if (startingSuccess) {
            CVReturn success = CVPixelBufferPoolCreatePixelBuffer (NULL, [_assetWriterInputPixelBufferAdaptor pixelBufferPool], &_wrotePixelBuffer);
            
            if (success != kCVReturnSuccess) {
                NSLog(@"error");
                
            }
            CVPixelBufferLockBaseAddress(_wrotePixelBuffer, 0);
            [_writerTexture setupContentWithCVBuffer:_wrotePixelBuffer];
            CVPixelBufferUnlockBaseAddress(_wrotePixelBuffer, 0);

            _frameTime = CMTimeMakeWithSeconds(0, 1000);
            if (_frameRate) {
                _frameTime = CMTimeMakeWithSeconds(0, 1000);
            }
            else {
                _frameTime = time;
            }
            _startTime = _frameTime;
            
            [_assetWriter startSessionAtSourceTime:_frameTime];
            self.status = MIAudioVideoWriterStatusWriting;
            _lastAudioBufferTimeStamp = kCMTimeZero;
        }
        else {
            NSLog(@"MetalImage Error at %s, MIAudioVideoWriter can not be start in status: %d, error description:%@.", __FUNCTION__, (int)_assetWriter.status, _assetWriter.error);
            return;
        }
    } else if (self.status == MIAudioVideoWriterStatusWriting) {
        
        if (_frameRate) {
            _frameTime = CMTimeAdd(_frameTime, CMTimeMakeWithSeconds(1.0 / _frameRate, 1000));
        }
        else {
            _frameTime = time;
        }
        
        if ([self.delegate respondsToSelector:@selector(audioVideoWriter:isWritingAtTime:)]) {
            [self.delegate audioVideoWriter:self isWritingAtTime:CMTimeSubtract(_frameTime, _startTime)];
        }
    }
    
    if (!_positionBuffer ) {
        _positionBuffer = [MIContext createBufferWithLength:4 * sizeof(vector_float4)];
    }
    
    if (!CGRectEqualToRect(_preRenderRect, rect)) {
        _preRenderRect = rect;
        [MIContext updateBufferContent:_positionBuffer contentSize:self.contentSize outputFrame:rect];
    }
    
    id<MTLTexture> framebufferTexture = _writerTexture.mtlTexture;
    _passDescriptor.colorAttachments[0].texture = framebufferTexture;
    _passDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 0.0);
    _passDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    _passDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    
    id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:_passDescriptor];
    [commandEncoder setRenderPipelineState:_renderPipelineState];
    [commandEncoder setViewport:(MTLViewport){0, 0, self.contentSize.width,self.contentSize.height, 0.0, 1.0}];
    
    [commandEncoder setVertexBuffer:_positionBuffer offset:0 atIndex:0];
    [commandEncoder setVertexBuffer:_inputTexture.textureCoordinateBuffer offset:0 atIndex:1];
    
    [commandEncoder setFragmentTexture:_inputTexture.mtlTexture atIndex:0];
    
    [commandEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip vertexStart:0 vertexCount:4];
    [commandEncoder endEncoding];
    
    if (_assetWriterVideoInput.isReadyForMoreMediaData) {
        CVPixelBufferLockBaseAddress(_wrotePixelBuffer, 0);        
        BOOL appendingSuccess = [_assetWriterInputPixelBufferAdaptor appendPixelBuffer:_wrotePixelBuffer withPresentationTime:_frameTime];
        if(!appendingSuccess)
        {
            NSLog(@"MetalImage Error at MIAudioVideoWriter renderRect:atTime: , message: Problem appending pixel buffer at time: %f .", CMTimeGetSeconds(_frameTime));
        }
        CVPixelBufferUnlockBaseAddress(_wrotePixelBuffer, 0);
    }
    
    if (self.shouldWriteWithAudio) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(audioVideoWriterRequestNextAudioSampleBuffer:)]) {
            if (_assetWriterAudioInput.isReadyForMoreMediaData) {
                [self.delegate audioVideoWriterRequestNextAudioSampleBuffer:self];
            }
        }
    }
}


#pragma mark -

- (BOOL)startWriting {
    NSError *error = nil;
    _assetWriter = [[AVAssetWriter alloc] initWithURL:self.outputURL fileType:_fileType error:&error];
    if (error) {
        return NO;
    }
    _assetWriter.movieFragmentInterval = CMTimeMakeWithSeconds(0.1, 1000);
    
    if (!_outputSettings) {
        _outputSettings = [[NSMutableDictionary alloc] init];
        [_outputSettings setObject:AVVideoCodecH264 forKey:AVVideoCodecKey];
    } else {
        NSString *videoCodec = [_outputSettings objectForKey:AVVideoCodecKey];
        
        if (!videoCodec) {
            return NO;
        }
    }
    [_outputSettings setObject:[NSNumber numberWithInt:self.contentSize.width] forKey:AVVideoWidthKey];
    [_outputSettings setObject:[NSNumber numberWithInt:self.contentSize.height] forKey:AVVideoHeightKey];
    
    _assetWriterVideoInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo outputSettings:_outputSettings];
    _assetWriterVideoInput.expectsMediaDataInRealTime = YES;
    
    NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey,
                                                           [NSNumber numberWithInt:self.contentSize.width], kCVPixelBufferWidthKey,
                                                           [NSNumber numberWithInt:self.contentSize.height], kCVPixelBufferHeightKey,
                                                           nil];
    
    _assetWriterInputPixelBufferAdaptor = [[AVAssetWriterInputPixelBufferAdaptor alloc] initWithAssetWriterInput:_assetWriterVideoInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    
    
    if ([_assetWriter canAddInput:_assetWriterVideoInput]) {
        [_assetWriter addInput:_assetWriterVideoInput];
    } else {
        return NO;
    }
    
    if (self.shouldWriteWithAudio) {
//        if (!self.compressionAudioSettings) {
//            // Configure the channel layout as stereo.
//            AudioChannelLayout stereoChannelLayout = {
//                .mChannelLayoutTag = kAudioChannelLayoutTag_Stereo,
//                .mChannelBitmap = 0,
//                .mNumberChannelDescriptions = 0
//            };
//
//            // Convert the channel layout object to an NSData object.
//            NSData *channelLayoutAsData = [NSData dataWithBytes:&stereoChannelLayout length:offsetof(AudioChannelLayout, mChannelDescriptions)];
//
//            // Get the compression settings for 128 kbps AAC.
//            NSDictionary *compressionAudioSettings = @{
//                                                       AVFormatIDKey         : [NSNumber numberWithUnsignedInt:kAudioFormatMPEG4AAC],
//                                                       AVEncoderBitRateKey   : [NSNumber numberWithInteger:128000],
//                                                       AVSampleRateKey       : [NSNumber numberWithInteger:44100],
//                                                       AVChannelLayoutKey    : channelLayoutAsData,
//                                                       AVNumberOfChannelsKey : [NSNumber numberWithUnsignedInteger:2]
//                                                       };
//
//            self.compressionAudioSettings = compressionAudioSettings;
//        }
        
        _assetWriterAudioInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeAudio outputSettings:self.compressionAudioSettings];
        _assetWriterAudioInput.expectsMediaDataInRealTime = self.isWritingInRealTime;
        
        if ([_assetWriter canAddInput:_assetWriterAudioInput]) {
            [_assetWriter addInput:_assetWriterAudioInput];
        } else {
            NSLog(@"MetalImage Error at %s", __FUNCTION__);
            return NO;
        }
    }
    return YES;
}

- (void)finishWriting {
    if (self.status != MIAudioVideoWriterStatusWriting) {
        return;
    }
    
    self.status = MIAudioVideoWriterStatusCompleted;
    
    if (!_audioWritingCompleted && self.shouldWriteWithAudio) {
        [_assetWriterAudioInput markAsFinished];
        _audioWritingCompleted = YES;
    }
    
    //如果最后一帧编码的音频buffer时间超过视频buffer的时间，会造成视频最后一段画面空白，故这里补上最后一帧。
    if (self.shouldWriteWithAudio && _wrotePixelBuffer  && _assetWriterVideoInput.isReadyForMoreMediaData && CMTIME_IS_VALID(_lastAudioBufferTimeStamp) && CMTimeCompare(_frameTime, _lastAudioBufferTimeStamp) < 0) {
        CVPixelBufferLockBaseAddress(_wrotePixelBuffer, 0);
        
        //确保视频帧是关键帧
        CMTime differenceTime = CMTimeSubtract(_lastAudioBufferTimeStamp, _frameTime);
        if (CMTimeCompare(differenceTime, CMTimeMake(1, 30)) < 0) {
            _lastAudioBufferTimeStamp = CMTimeAdd(_lastAudioBufferTimeStamp, CMTimeMake(1, 30));
        }
        BOOL appendingSuccess = [_assetWriterInputPixelBufferAdaptor appendPixelBuffer:_wrotePixelBuffer withPresentationTime:_lastAudioBufferTimeStamp];
        if(!appendingSuccess) {
            NSLog(@"MetalImage Error at MIAudioVideoWriter finishWriting, message: Problem appending pixel buffer at time: %f .", CMTimeGetSeconds(_lastAudioBufferTimeStamp));
        }
        CVPixelBufferUnlockBaseAddress(_wrotePixelBuffer, 0);
    }
    
    [_assetWriterVideoInput markAsFinished];
    
    [_assetWriter finishWritingWithCompletionHandler:^{
        [self deleteAssetWriter];
        _audioWritingCompleted = NO;
        self.status = MIAudioVideoWriterStatusWaiting;
        if (self.delegate && [self.delegate respondsToSelector:@selector(audioVideoWriterDidfinishWriting:)]) {
            [self.delegate audioVideoWriterDidfinishWriting:self];
        }
    }];
}


#pragma - Audio Sample Buffer Writing Methods

- (void)writeWithAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    if (!self.isEnabled || !self.shouldWriteWithAudio || self.status != MIAudioVideoWriterStatusWriting || _audioWritingCompleted) {
        return;
    }
    
    if (sampleBuffer == NULL || CMTIME_IS_INVALID(CMSampleBufferGetPresentationTimeStamp(sampleBuffer))) {
        if (!_audioWritingCompleted) {
            [_assetWriterAudioInput markAsFinished];
            _audioWritingCompleted = YES;
        }
        return;
    }
    
    if (_assetWriterAudioInput.isReadyForMoreMediaData) {
        BOOL secussed = [_assetWriterAudioInput appendSampleBuffer:sampleBuffer];
        if (secussed) {
            _lastAudioBufferTimeStamp = CMSampleBufferGetOutputPresentationTimeStamp(sampleBuffer);
        }
        else {
            NSLog(@"MetalImage Error at MIAudioVideoWriter writeWithAudioSampleBuffer:, message: fail to append audio SampleBuffer.");
            if (_assetWriter.status == AVAssetWriterStatusFailed) {
                NSLog(@"Writer status is AVAssetWriterStatusFailed, because of error: %@.", _assetWriter.error);
            }
        }
    }
}

- (void)deleteAssetWriter {
    if (_assetWriter) {
        _assetWriter = nil;
    }
    if (_assetWriterAudioInput) {
        _assetWriterAudioInput = nil;
    }
    if (_assetWriterVideoInput) {
        _assetWriterVideoInput = nil;
    }
    if (_assetWriterInputPixelBufferAdaptor) {
        _assetWriterInputPixelBufferAdaptor = nil;
    }
}


@end
