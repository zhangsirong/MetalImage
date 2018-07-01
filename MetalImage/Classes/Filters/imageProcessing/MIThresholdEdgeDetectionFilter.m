//
//  MIThresholdEdgeDetectionFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIThresholdEdgeDetectionFilter.h"

@implementation MIThresholdEdgeDetectionFilter

- (instancetype)init {
    if (self = [super init]) {
        _thresholdBuffer = [MIContext createBufferWithLength:sizeof(float)];
        self.threshold = 0.25;
        self.edgeStrength = 1.0;
        
    }
    return self;
}

- (void)setThreshold:(float)threshold {
    _threshold = threshold;
    float *thresholds = _thresholdBuffer.contents;
    thresholds[0] = threshold;
}

- (void)setSecondVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setSecondVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_thresholdBuffer offset:0 atIndex:1];
}

+ (NSString *)secondFragmentShaderFunction {
    NSString *fFunction = @"MIThresholdEdgeDetectionFragmentShader";
    return fFunction;
}
@end
