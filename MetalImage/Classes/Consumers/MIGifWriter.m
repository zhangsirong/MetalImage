//
//  MIGifWriter.m
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIGifWriter.h"
#import "MIContext.h"
#import "MITexture.h"
#import <CoreGraphics/CoreGraphics.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define kMIGIFFrameRate  (9.0f)    //GIF帧频设置为9.0

@interface MIGifWriter ()

@end


@implementation MIGifWriter

- (instancetype)init {
    if (self = [super init]) {
        _frameTime = kCMTimeZero;
        self.enabled = NO;
        _renderPipelineState = [MIContext createRenderPipelineStateWithVertexFunction:@"MIDefaultVertexShader"
                                                                     fragmentFunction:@"MIDefaultFragmentShader"];
        _passDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
        _images = [NSMutableArray arrayWithCapacity:30];
        _maxFrame = 27;
    }
    return self;
}

- (instancetype)initWithContentSize:(CGSize)contentSize outputURL:(NSURL *)outputURL maxFrame:(int)maxFrame{
    if (self = [self init]) {
        self.outputURL = outputURL;
        _contentSize = contentSize;
        _maxFrame = maxFrame;
    }
    return self;
}

- (void)renderRect:(CGRect)rect atTime:(CMTime)time commandBuffer:(id<MTLCommandBuffer>)commandBuffer {
    if (!self.isEnabled || _recordedFrameCount > _maxFrame || !_inputTexture) {
        return;
    }

    if (CGSizeEqualToSize(self.contentSize, CGSizeZero)) {
        self.contentSize = _inputTexture.size;
    }
    
    if (!_positionBuffer ) {
        _positionBuffer = [MIContext createBufferWithLength:4 * sizeof(vector_float4)];
    }
    
    if (!CGRectEqualToRect(_preRenderRect, rect)) {
        _preRenderRect = rect;
        [MIContext updateBufferContent:_positionBuffer contentSize:self.contentSize outputFrame:rect];
    }
    
    if (!_outputTexture || !CGSizeEqualToSize(self.contentSize, _outputTexture.size)) {
        _outputTexture = [[MITexture alloc] initWithSize:self.contentSize];
    }
    
    if (CMTimeCompare(_frameTime, kCMTimeZero) == 0) { //0代表相等
        _frameTime = time;
    } else {
        CMTime delta = CMTimeSubtract(time, _frameTime);
        if (CMTimeGetSeconds(delta) < 1.0/kMIGIFFrameRate) {
            return;
        }
    }
    _frameTime = time;
    
    
    id<MTLTexture> framebufferTexture = _outputTexture.mtlTexture;
    
    _passDescriptor.colorAttachments[0].texture = framebufferTexture;
    _passDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1);
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
    
    [commandBuffer addCompletedHandler:^(id<MTLCommandBuffer> commandBuffer) {
        UIImage *frame = [_outputTexture imageFromMTLTexture];
        if (frame) {
            if(_recordedFrameCount >= _maxFrame) {
                [self finishWriting];
            }
            else {
                UIImage *image = [self imagefromFrame:frame];
                [_images addObject:image];
                if (self.delegate && [self.delegate respondsToSelector:@selector(gifWriter:didAddImageWithIndex:)]) {
                    [self.delegate gifWriter:self didAddImageWithIndex:_recordedFrameCount];
                }
            }
            _recordedFrameCount++;
        }
    }];
    
}

- (void)finishWriting {
    
    [self createGifFile];
    if (self.delegate && [self.delegate respondsToSelector:@selector(gifWriterDidFinishWriting:)]) {
        [self.delegate gifWriterDidFinishWriting:self];
    }
    
    [_images removeAllObjects];
    _recordedFrameCount = 0;
    self.enabled = NO;
}

- (void)createGifFile {
    NSString *filePath = self.outputURL.path;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    NSUInteger frameCount = _images.count;
    
    NSDictionary *fileProperties = @{ (__bridge id)kCGImagePropertyGIFDictionary: @{(__bridge id)kCGImagePropertyGIFLoopCount: @0,}};//循环次数
    NSDictionary *frameProperties = @{ (__bridge id)kCGImagePropertyGIFDictionary: @{(__bridge id)kCGImagePropertyGIFDelayTime: @(1.0/kMIGIFFrameRate)}};//每帧的时间
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)self.outputURL, kUTTypeGIF, frameCount, NULL);
    
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
    
    for (NSUInteger i = 0; i < frameCount; i++) {
        UIImage *image = _images[i];
        CGImageDestinationAddImage(destination, image.CGImage, (__bridge CFDictionaryRef)frameProperties);
    }
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    
    CFRelease(destination);
}

- (UIImage *)imagefromFrame:(UIImage *)scrImage {
    @synchronized (self) {
        @autoreleasepool {
            CGAffineTransform transform = CGAffineTransformIdentity;
            switch (self.orientation) {
                case UIDeviceOrientationPortrait:
                    break;
                    
                case UIDeviceOrientationPortraitUpsideDown:
                    transform = CGAffineTransformTranslate(transform, scrImage.size.width, scrImage.size.height);
                    transform = CGAffineTransformRotate(transform, M_PI);
                    break;

                case UIDeviceOrientationLandscapeLeft:
                    transform = CGAffineTransformTranslate(transform, scrImage.size.width, 0);
                    transform = CGAffineTransformRotate(transform, M_PI_2);
                    break;

                case UIDeviceOrientationLandscapeRight:
                    transform = CGAffineTransformTranslate(transform, 0, scrImage.size.height);
                    transform = CGAffineTransformRotate(transform, -M_PI_2);
                    break;
                    
                default:
                    break;
            }
            
            CGContextRef ctx = CGBitmapContextCreate(NULL, scrImage.size.width, scrImage.size.height, CGImageGetBitsPerComponent(scrImage.CGImage), 0, CGImageGetColorSpace(scrImage.CGImage), kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
            
            CGContextConcatCTM(ctx, transform);
            
            CGContextDrawImage(ctx, CGRectMake(0, 0, scrImage.size.width, scrImage.size.height), scrImage.CGImage);
            
            CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
            UIImage *image = [UIImage imageWithCGImage:cgImage];
            CGContextRelease(ctx);
            CGImageRelease(cgImage);
            return image;
        }
    }
}

- (void)setInputTexture:(MITexture *)inputTexture {
    _inputTexture = inputTexture;
}



@end

