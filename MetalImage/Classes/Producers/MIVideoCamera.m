//
//  MIVideoCamera.m
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//44

#import "MIVideoCamera.h"
#import "MIContext.h"

@interface MIVideoCamera ()
{
    AVCaptureSession *_microphoneSession;
    dispatch_queue_t _microphoneQueue;
    AVCaptureDevice *_microphone;
    AVCaptureDeviceInput *_audioInput;
    AVCaptureAudioDataOutput *_audioOutput;
    AVCaptureStillImageOutput *_stillImageOutput;//iOS9用    
}

@end

@implementation MIVideoCamera

@dynamic delegate;

- (instancetype)initWithCameraPosition:(AVCaptureDevicePosition)cameraPosition sessionPreset:(NSString *)sessionPreset {
    if (self = [super initWithCameraPosition:cameraPosition sessionPreset:sessionPreset]) {
        [self configCapturePhoto];
        [self configAudio];
    }
    return self;
}

- (void)configAudio {
    
    _microphoneSession = [[AVCaptureSession alloc] init];
    [_microphoneSession beginConfiguration];

    _microphone = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error = nil;
    
    _audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:_microphone error:&error];
    if (error) {
        NSLog(@"MetalImage Error: %@ %s.", error, __FUNCTION__);
    }

    if ([_microphoneSession canAddInput:_audioInput])     {
        [_microphoneSession addInput:_audioInput];
    } else {
        NSLog(@"MetalImage Error: %s", __FUNCTION__);
    }
    
    _microphoneQueue = dispatch_queue_create("com.beauty.MetalImage.microphoneQueue", NULL);

    _audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    [_audioOutput setSampleBufferDelegate:self queue:_microphoneQueue];
    
    if ([_microphoneSession canAddOutput:_audioOutput]) {
        [_microphoneSession addOutput:_audioOutput];
    } else {
        NSLog(@"MetalImage Error: %s", __FUNCTION__);
    }
    [_microphoneSession commitConfiguration];
    
    _recommendedAudioSettings = [_audioOutput recommendedAudioSettingsForAssetWriterWithOutputFileType:AVFileTypeQuickTimeMovie];

}

- (void)setAudioEnabled:(BOOL)audioEnabled {
    _audioEnabled = audioEnabled;
    
    if (_audioEnabled) {
        if (!_microphoneSession.isRunning) {
            [_microphoneSession startRunning];
        }
    } else {
        if (_microphoneSession.isRunning) {
            [_microphoneSession stopRunning];
        }
    }
}


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate & AVCaptureAudioDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (!self.isEnabled) {
        return;
    }
    
    if (captureOutput == _audioOutput) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoCamera:didReceiveAudioSampleBuffer:)]) {
            CFRetain(sampleBuffer);
            [MIContext performAsynchronouslyOnImageProcessingQueue:^{
                [self.delegate videoCamera:self didReceiveAudioSampleBuffer:sampleBuffer];
                CFRelease(sampleBuffer);
            }];
        }
    } else if (captureOutput == _videoOutput) {
        [super captureOutput:captureOutput didOutputSampleBuffer:sampleBuffer fromConnection:connection];
    }
}


#pragma mark - Capture Photo

- (void)configCapturePhoto {
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    _stillImageOutput.outputSettings = @{(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA)};
}

- (void)setPhotoCaptureEnabled:(BOOL)photoCaptureEnabled {
    _photoCaptureEnabled = photoCaptureEnabled;
    
    [_cameraSession beginConfiguration];
    
    if (_photoCaptureEnabled) {
        if (![_cameraSession.outputs containsObject:_stillImageOutput]) {
            if ([_cameraSession canAddOutput:_stillImageOutput]) {
                [_cameraSession addOutput:_stillImageOutput];
            } else {
                NSLog(@"MetalImage Error: %s", __FUNCTION__);
            }
        }
    } else {
        if ([_cameraSession.outputs containsObject:_stillImageOutput]) {
            [_cameraSession removeOutput:_stillImageOutput];
        }
    }
    
    [_cameraSession commitConfiguration];
}


#pragma mark - Publish

- (void)captureImageSampleBufferAsynchronouslyWithCompletionHandler:(void (^)(CMSampleBufferRef imageSampleBuffer, NSError *error))handler {
    if(_stillImageOutput.isCapturingStillImage){
        handler(NULL, [NSError errorWithDomain:AVFoundationErrorDomain code:AVErrorMaximumStillImageCaptureRequestsExceeded userInfo:nil]);
        return;
    }
    AVCaptureConnection *videoConnection = [_stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        handler(NULL, [NSError errorWithDomain:AVFoundationErrorDomain code:AVErrorDeviceNotConnected userInfo:nil]);
        return;
    }
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error){
        handler(imageSampleBuffer, error);
    }];
}

- (void)captureOriginalImageAsynchronouslyWithCompletionHandler:(void (^)(UIImage *originalImage, NSError *error))handler {
    [self captureImageSampleBufferAsynchronouslyWithCompletionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error){
        if (imageSampleBuffer == NULL) {
            handler(nil, error);
            return;
        }
        
        UIImage *originalImage = [self imageFromSampleBuffer:imageSampleBuffer];
        handler(originalImage, error);
    }];
}


#pragma mark -

- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
    @autoreleasepool {
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CVPixelBufferLockBaseAddress(imageBuffer, 0);
        uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
        
        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
        
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef quartzContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
        
        CGImageRef quartzImage = CGBitmapContextCreateImage(quartzContext);
        
        //调整方向
        CGSize realSize;
        
        if (self.orientation == UIDeviceOrientationLandscapeLeft || self.orientation == UIDeviceOrientationLandscapeRight) {
            realSize = CGSizeMake(width, height);
        } else {
            realSize = CGSizeMake(height, width);
        }
        
        UIGraphicsBeginImageContextWithOptions(realSize, NO, 1.0f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        switch (self.orientation) {
            case UIDeviceOrientationPortrait:
                if (_position == AVCaptureDevicePositionFront) {
                    CGContextRotateCTM(context, M_PI_2);
                    CGContextTranslateCTM(context, 0, -(float)height);
                } else {
                    CGContextRotateCTM(context, M_PI_2);
                    CGContextTranslateCTM(context, 0, -(float)height);
                    CGContextScaleCTM(context, 1.0, -1.0);
                    CGContextTranslateCTM(context, 0.0, -(float)height);
                }
                break;
                
            case UIDeviceOrientationPortraitUpsideDown:
                if (_position == AVCaptureDevicePositionFront) {
                    CGContextRotateCTM(context, -M_PI_2);
                    CGContextTranslateCTM(context, -(float)width, 0.0);
                } else {
                    CGContextRotateCTM(context, -M_PI_2);
                    CGContextTranslateCTM(context, -(float)width, 0.0);
                    CGContextScaleCTM(context, 1.0, -1.0);
                    CGContextTranslateCTM(context, 0.0, -(float)height);
                }
                break;
                
            case UIDeviceOrientationLandscapeLeft:
                if (_position == AVCaptureDevicePositionFront) {
                    
                } else {
                    CGContextRotateCTM(context, M_PI);
                    CGContextTranslateCTM(context, -(float)width, -(float)height);
                    CGContextScaleCTM(context, -1.0, 1.0);
                    CGContextTranslateCTM(context, -(float)width, 0.0);
                }
                break;
                
            case UIDeviceOrientationLandscapeRight:
                if (_position == AVCaptureDevicePositionFront) {
                    CGContextRotateCTM(context, M_PI);
                    CGContextTranslateCTM(context, -(float)width, -(float)height);
                } else {
                    CGContextScaleCTM(context, -1.0, 1.0);
                    CGContextTranslateCTM(context, -(float)width, 0.0);
                }
                
                break;
            default:
                
                break;
        }
        
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), quartzImage);
        UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGImageRelease(quartzImage);
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(quartzContext);
        CVPixelBufferUnlockBaseAddress(imageBuffer,0);
        
        return imageCopy;
    }
}

@end
