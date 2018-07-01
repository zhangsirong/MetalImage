//
//  MISwirlFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MISwirlFilter.h"

@implementation MISwirlFilter

- (instancetype)init {
    if (self = [super init]) {
        _centerBuffer = [MIContext createBufferWithLength:sizeof(vector_float2)];
        _radiusBuffer = [MIContext createBufferWithLength:sizeof(float)];
        _angleBuffer = [MIContext createBufferWithLength:sizeof(float)];
        
        self.radius = 0.5;
        self.angle = 1.0;
        self.center = CGPointMake(0.5, 0.5);
    }
    return self;
}

- (void)setCenter:(CGPoint)center {
    _center = center;
    
    vector_float2 *centers = _centerBuffer.contents;
    centers[0] = vector2((float)center.x, (float)center.y);
}

- (void)setRadius:(float)radius {
    _radius = radius;
    
    float *radiuss = _radiusBuffer.contents;
    radiuss[0] = radius;
}

- (void)setAngle:(float)angle {
    _angle = angle;
    float *angles = _angleBuffer.contents;
    angles[0] = angle;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_centerBuffer offset:0 atIndex:0];
    [commandEncoder setFragmentBuffer:_radiusBuffer offset:0 atIndex:1];
    [commandEncoder setFragmentBuffer:_angleBuffer offset:0 atIndex:2];
}

+ (NSString *)fragmentShaderFunction {
    NSString *funciton = @"MISwirlFragmentShader";
    return funciton;
}
@end

