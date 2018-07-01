//
//  MIHazeFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIHazeFilter.h"

@implementation MIHazeFilter


- (instancetype)init {
    if (self = [super init]) {
        _distanceBuffer = [MIContext createBufferWithLength:sizeof(float)];
        _slopeBuffer = [MIContext createBufferWithLength:sizeof(float)];
        self.distance = 0.2;
        self.slope = 0.0;
    }
    return self;
}

- (void)setDistance:(float)distance {
    _distance = distance;
    float *distances = _distanceBuffer.contents;
    distances[0] = _distance;
}

- (void)setSlope:(float)slope {
    _slope = slope;
    float *slopes = _slopeBuffer.contents;
    slopes[0] = slope;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_distanceBuffer offset:0 atIndex:0];
    [commandEncoder setFragmentBuffer:_slopeBuffer offset:0 atIndex:1];
}

+ (NSString *)fragmentShaderFunction {
    NSString *funciton = @"MIHazeFragmentShader";
    return funciton;
}



@end
