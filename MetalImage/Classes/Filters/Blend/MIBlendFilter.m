//
//  MIBlendFilter.m
//  MetalImage
//
//  Created by zsr on 2018/07/10.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIBlendFilter.h"

@implementation MIBlendFilter

- (instancetype)init {
    if (self = [super init]) {
        _intensityBuffer = [MIContext createBufferWithLength:sizeof(float)];
        _blendModeBuffer = [MIContext createBufferWithLength:sizeof(int)];
        self.blendMode = MIBlendModeNormal;
        self.intensity = 1.0;
    }
    return self;
}

- (void)setIntensity:(float)intensity {
    _intensity = intensity;
    float *intensitys = _intensityBuffer.contents;
    intensitys[0] = _intensity;
}

- (void)setBlendMode:(MIBlendMode)blendMode {
    _blendMode = blendMode;
    int *blendModes = _blendModeBuffer.contents;
    blendModes[0] = _blendMode;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_blendModeBuffer offset:0 atIndex:0];
    [commandEncoder setFragmentBuffer:_intensityBuffer offset:0 atIndex:1];
}

+ (NSString *)fragmentShaderFunction {
    NSString *funciton = @"MIBlendFragmentShader";
    return funciton;
}

@end
