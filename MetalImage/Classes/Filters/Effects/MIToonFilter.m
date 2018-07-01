//
//  MIToonFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIToonFilter.h"

@implementation MIToonFilter

- (instancetype)init {
    if (self = [super init]) {
        _thresholdBuffer = [MIContext createBufferWithLength:sizeof(float)];
        _quantizationLevelsBuffer = [MIContext createBufferWithLength:sizeof(float)];
        
        self.threshold = 0.2;
        self.quantizationLevels = 10.0;
    }
    return self;
}

- (void)setThreshold:(float)threshold {
    _threshold = threshold;
    float *thresholds = _thresholdBuffer.contents;
    thresholds[0] = _threshold;
}

- (void)setQuantizationLevels:(float)quantizationLevels {
    _quantizationLevels = quantizationLevels;
    float *quantizationLevelss = _quantizationLevelsBuffer.contents;
    quantizationLevelss[0] = _quantizationLevels;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_thresholdBuffer offset:0 atIndex:0];
    [commandEncoder setFragmentBuffer:_quantizationLevelsBuffer offset:0 atIndex:1];
}

+ (NSString *)fragmentShaderFunction {
    NSString *funciton = @"MIToonFragmentShader";
    return funciton;
}

@end
