//
//  MIPixellatePositionFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIPixellatePositionFilter.h"

@interface MIPixellatePositionFilter ()
{
    id<MTLBuffer> _pixelPositionBuffer;//vector_float(cneterx,centery)
    id<MTLBuffer> _pixelRadiusBuffer;
    
}
@end

@implementation MIPixellatePositionFilter

- (instancetype)init {
    if (self = [super init]) {
        _pixelPositionBuffer = [[MIContext sharedContext].device newBufferWithLength:sizeof(vector_float2) options:MTLResourceOptionCPUCacheModeDefault];
        _pixelRadiusBuffer = [[MIContext sharedContext].device newBufferWithLength:sizeof(float) options:MTLResourceOptionCPUCacheModeDefault];
        
        self.center = CGPointMake(0.5, 0.5);
        self.radius = 0.5;
    }
    return self;
}

- (void)setCenter:(CGPoint)center {
    _center = center;
    float centerX = center.x;
    float centerY = center.y;
    vector_float2 *pixelPosition = _pixelPositionBuffer.contents;
    pixelPosition[0] = vector2(centerX, centerY);
}

- (void)setRadius:(float)radius {
    _radius = radius;
    
    float *pixelRadius = _pixelRadiusBuffer.contents;
    pixelRadius[0] = radius;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_pixelPositionBuffer offset:0 atIndex:3];
    [commandEncoder setFragmentBuffer:_pixelRadiusBuffer offset:0 atIndex:4];
}

+ (NSString *)fragmentShaderFunction
{
    static NSString *fFunction = @"MIPixellatePositionFragmentShader";
    return fFunction;
}


@end
