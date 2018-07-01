//
//  MIStretchDistortionFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIStretchDistortionFilter.h"

@implementation MIStretchDistortionFilter

- (instancetype)init {
    if (self = [super init]) {
        _centerBuffer = [MIContext createBufferWithLength:sizeof(vector_float2)];
        self.center = CGPointMake(0.5, 0.5);
    }
    return self;
}

- (void)setCenter:(CGPoint)center {
    _center = center;
    
    vector_float2 *centers = _centerBuffer.contents;
    centers[0] = vector2((float)center.x, (float)center.y);
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_centerBuffer offset:0 atIndex:0];
}

+ (NSString *)fragmentShaderFunction {
    NSString *funciton = @"MIStretchDistortionFragmentShader";
    return funciton;
}

@end
