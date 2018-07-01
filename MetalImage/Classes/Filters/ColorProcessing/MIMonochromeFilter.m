//
//  MIMonochromeFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIMonochromeFilter.h"

@implementation MIMonochromeFilter

- (instancetype)init {
    if (self = [super init]) {
        
        _intensityBuffer = [MIContext createBufferWithLength:sizeof(float)];
        _filterColorBuffer = [MIContext createBufferWithLength:sizeof(vector_float3)];
        self.intensity = 1.0;
        self.color = vector4(0.6f, 0.45f, 0.3f, 1.0f);
    }
    return self;
}

- (void)setColor:(vector_float4)color {
    _color = color;
    vector_float3 *colors = _filterColorBuffer.contents;
    colors[0] = _color.xyz;
}


- (void)setIntensity:(float)intensity {
    _intensity = intensity;
    float *intensitys = _intensityBuffer.contents;
    intensitys[0] = _intensity;
}

- (void)setColorRed:(float)redComponent green:(float)greenComponent blue:(float)blueComponent {
    self.color = vector4(redComponent, greenComponent, blueComponent, 1.0f);
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_intensityBuffer offset:0 atIndex:0];
    [commandEncoder setFragmentBuffer:_filterColorBuffer offset:0 atIndex:1];
}

+ (NSString *)fragmentShaderFunction {
    NSString *funciton = @"MIMonochromeFragmentShader";
    return funciton;
}


@end
