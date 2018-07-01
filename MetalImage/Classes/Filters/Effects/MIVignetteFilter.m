//
//  MIVignetteFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIVignetteFilter.h"

@implementation MIVignetteFilter

- (instancetype)init {
    if (self = [super init]) {
        _vignetteCenterBuffer = [MIContext createBufferWithLength:sizeof(vector_float2)];
        _vignetteColorBuffer = [MIContext createBufferWithLength:sizeof(vector_float3)];
        _vignetteStartBuffer = [MIContext createBufferWithLength:sizeof(float)];
        _vignetteEndBuffer = [MIContext createBufferWithLength:sizeof(float)];
        
        self.vignetteCenter = CGPointMake(0.5f, 0.5f);
        self.vignetteColor = vector3(0.0f, 0.0f, 0.0f);
        self.vignetteStart = 0.3;
        self.vignetteEnd = 0.75;
    }
    return self;
}

- (void)setVignetteCenter:(CGPoint)newValue {
    _vignetteCenter = newValue;
    vector_float2 *vignetteCenters = _vignetteCenterBuffer.contents;
    vignetteCenters[0] = vector2((float)_vignetteCenter.x, (float)_vignetteCenter.y);
}

- (void)setVignetteColor:(vector_float3)newValue {
    _vignetteColor = newValue;
    vector_float3 *vignetteColors = _vignetteColorBuffer.contents;
    vignetteColors[0] = _vignetteColor;
}

- (void)setVignetteStart:(float)newValue {
    _vignetteStart = newValue;
    float *vignetteStarts = _vignetteStartBuffer.contents;
    vignetteStarts[0] = _vignetteStart;
}

- (void)setVignetteEnd:(float)newValue {
    _vignetteEnd = newValue;
    float *vignetteEnds = _vignetteEndBuffer.contents;
    vignetteEnds[0] = _vignetteEnd;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_vignetteCenterBuffer offset:0 atIndex:0];
    [commandEncoder setFragmentBuffer:_vignetteColorBuffer offset:0 atIndex:1];
    [commandEncoder setFragmentBuffer:_vignetteStartBuffer offset:0 atIndex:2];
    [commandEncoder setFragmentBuffer:_vignetteEndBuffer offset:0 atIndex:3];
    
}

+ (NSString *)fragmentShaderFunction {
    NSString *function = @"MIVignetteFragmentShader";
    return function;
}



@end
