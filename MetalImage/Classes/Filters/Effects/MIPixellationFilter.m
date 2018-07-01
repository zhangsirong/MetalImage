//
//  MIPixellationFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIPixellationFilter.h"

@interface MIPixellationFilter ()
{
    id<MTLBuffer> _aspectRatioBuffer;
    id<MTLBuffer> _pixelWidthBuffer;
}
@end


@implementation MIPixellationFilter

- (instancetype)init {
    if (self = [super init]) {
        _aspectRatioBuffer = [[MIContext sharedContext].device newBufferWithLength:sizeof(float) options:MTLResourceOptionCPUCacheModeDefault];
        float *aspectRatio = _aspectRatioBuffer.contents;
        aspectRatio[0] = 1.0;
        
        _pixelWidthBuffer = [[MIContext sharedContext].device newBufferWithLength:sizeof(float) options:MTLResourceOptionCPUCacheModeDefault];
        float *pixel = _pixelWidthBuffer.contents;
        pixel[0] = 1/20.0;
    }
    return self;
}

- (void)setContentSize:(CGSize)contentSize {
    [super setContentSize:contentSize];
    if (contentSize.width != 0) {
        float *aspectRatio = _aspectRatioBuffer.contents;
        aspectRatio[0] = contentSize.height / contentSize.width;
    }
}


- (void)setFractionalWidthOfAPixel:(float)fractionalWidthOfAPixel {
    if (self.contentSize.width > 0) {
        CGFloat singlePixelSpacing = 1.0 / self.contentSize.width;
        if (fractionalWidthOfAPixel < singlePixelSpacing) {
            _fractionalWidthOfAPixel = singlePixelSpacing;
        } else{
            _fractionalWidthOfAPixel = fractionalWidthOfAPixel;
        }
    } else {
        _fractionalWidthOfAPixel = fractionalWidthOfAPixel;
    }
    
    float *pixel = _pixelWidthBuffer.contents;
    pixel[0] = _fractionalWidthOfAPixel;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_pixelWidthBuffer offset:0 atIndex:1];
    [commandEncoder setFragmentBuffer:_aspectRatioBuffer offset:0 atIndex:2];
}

+ (NSString *)fragmentShaderFunction {
    static NSString *fFunction = @"MIPixellationFragmentShader";
    return fFunction;
}

@end
