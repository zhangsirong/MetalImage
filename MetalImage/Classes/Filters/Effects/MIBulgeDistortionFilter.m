//
//  MIBulgeDistortionFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIBulgeDistortionFilter.h"

@interface MIBulgeDistortionFilter ()

@property  (nonatomic) float aspectRatio;

@end

@implementation MIBulgeDistortionFilter

- (instancetype)init {
    if (self = [super init]) {
        _aspectRatioBuffer = [MIContext createBufferWithLength:sizeof(float)];
        _centerBuffer = [MIContext createBufferWithLength:sizeof(vector_float2)];
        _radiusBuffer = [MIContext createBufferWithLength:sizeof(float)];
        _scaleBuffer = [MIContext createBufferWithLength:sizeof(float)];
        
        self.radius = 0.25;
        self.scale = 0.5;
        self.center = CGPointMake(0.5, 0.5);
        self.aspectRatio = 1.0;
    }
    return self;
}

- (void)setContentSize:(CGSize)contentSize {
    [super setContentSize:contentSize];
    
    if (contentSize.width != 0) {
        self.aspectRatio = contentSize.height / contentSize.width;
    }
}

- (void)setAspectRatio:(float)aspectRatio {
    _aspectRatio = aspectRatio;
    
    float *aspectRatios = _aspectRatioBuffer.contents;
    aspectRatios[0] = aspectRatio;
}

- (void)setCenter:(CGPoint)center
{
    _center = center;
    
    vector_float2 *centers = _centerBuffer.contents;
    centers[0] = vector2((float)center.x, (float)center.y);
}

- (void)setRadius:(float)radius {
    _radius = radius;
    
    float *radiuss = _radiusBuffer.contents;
    radiuss[0] = radius;
}

- (void)setScale:(float)scale {
    _scale = scale;
    float *scales = _scaleBuffer.contents;
    scales[0] = scale;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_aspectRatioBuffer offset:0 atIndex:0];
    [commandEncoder setFragmentBuffer:_centerBuffer offset:0 atIndex:1];
    [commandEncoder setFragmentBuffer:_radiusBuffer offset:0 atIndex:2];
    [commandEncoder setFragmentBuffer:_scaleBuffer offset:0 atIndex:3];
}

+ (NSString *)fragmentShaderFunction {
    NSString *funciton = @"MIBulgeDistortionFragmentShader";
    return funciton;
}

@end
