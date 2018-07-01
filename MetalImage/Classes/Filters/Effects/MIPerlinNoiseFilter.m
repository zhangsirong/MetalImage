//
//  MIPerlinNoiseFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIPerlinNoiseFilter.h"
@interface MIPerlinNoiseFilter ()
{
    id<MTLBuffer> _scaleBuffer;
    id<MTLBuffer> _colorStartFinishBuffer;
}
@end


@implementation MIPerlinNoiseFilter

- (instancetype)init {
    if (self = [super init]) {
        _scaleBuffer = [[MIContext sharedContext].device newBufferWithLength:sizeof(float) options:MTLResourceOptionCPUCacheModeDefault];
        float *scales = _scaleBuffer.contents;
        scales[0] = 8.0;
        
        _colorStartFinishBuffer = [[MIContext sharedContext].device newBufferWithLength:2 * sizeof(vector_float4) options:MTLResourceOptionCPUCacheModeDefault];
        vector_float4 *colorStartFinish = _colorStartFinishBuffer.contents;
        colorStartFinish[0] = vector4(1.0f, 0.0f, 0.0f, 1.0f);
        colorStartFinish[1] = vector4(1.0f, 1.0f, 1.0f, 1.0f);
        
    }
    return self;
}


- (void)setScale:(float)scale {
    _scale = scale;
    float *scales = _scaleBuffer.contents;
    scales[0] = scale;
}

- (void)setColorStart:(vector_float4)colorStart {
    _colorStart = colorStart;
    vector_float4 *colorStartFinish = _colorStartFinishBuffer.contents;
    colorStartFinish[0] = colorStart;
}

- (void)setColorFinish:(vector_float4)colorFinish {
    _colorFinish = colorFinish;
    vector_float4 *colorStartFinish = _colorStartFinishBuffer.contents;
    colorStartFinish[1] = colorFinish;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    
    [commandEncoder setFragmentBuffer:_scaleBuffer offset:0 atIndex:0];
    [commandEncoder setFragmentBuffer:_colorStartFinishBuffer offset:0 atIndex:1];
}

+ (NSString *)fragmentShaderFunction {
    static NSString *fFunction = @"MIPerlinNoiseFragmentShader";
    return fFunction;
}


@end
