//
//  MIColorMatrixFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIColorMatrixFilter.h"

@implementation MIColorMatrixFilter

- (instancetype)init {
    if (self = [super init]) {
        
        _colorMatrixBuffer = [MIContext createBufferWithLength:sizeof(matrix_float4x4)];
        _intensityBuffer = [MIContext createBufferWithLength:sizeof(float)];
        self.intensity = 1.0;
        self.colorMatrix = simd_matrix(vector4(1.0f, 0.0f, 0.0f, 0.0f),
                                       vector4(0.0f, 1.0f, 0.0f, 0.0f),
                                       vector4(0.0f, 0.0f, 1.0f, 0.0f),
                                       vector4(0.0f, 0.0f, 0.0f, 1.0f));
    }
    return self;
}

- (void)setIntensity:(float)intensity {
    _intensity = intensity;
    
    float *intensitys = _intensityBuffer.contents;
    intensitys[0] = _intensity;
}

- (void)setColorMatrix:(matrix_float4x4)newColorMatrix {
    _colorMatrix = newColorMatrix;
    matrix_float4x4 *colorMatrixs = _colorMatrixBuffer.contents;
    colorMatrixs[0] = _colorMatrix;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_intensityBuffer offset:0 atIndex:0];
    [commandEncoder setFragmentBuffer:_colorMatrixBuffer offset:0 atIndex:1];
}

+ (NSString *)fragmentShaderFunction {
    NSString *funciton = @"MIColorMatrixFragmentShader";
    return funciton;
}

@end
