//
//  MISobelEdgeDetectionFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MISobelEdgeDetectionFilter.h"

@implementation MISobelEdgeDetectionFilter

- (instancetype)init
{
    if (self = [super init]) {
        _texelWidthBuffer = [MIContext createBufferWithLength:sizeof(float)];
        _texelHeightBuffer = [MIContext createBufferWithLength:sizeof(float)];
        _edgeStrengthBuffer = [MIContext createBufferWithLength:sizeof(float)];
        
        self.texelWidth = 1.0 / 750;
        self.texelHeight = 1.0 / 1000;
        self.edgeStrength = 1.0;
    }
    return self;
}

- (void)setTexelWidth:(float)texelWidth {
    _texelWidth = texelWidth;
    float *texelWidths = _texelWidthBuffer.contents;
    texelWidths[0] = _texelWidth;
}

- (void)setTexelHeight:(float)texelHeight {
    _texelHeight = texelHeight;
    float *texelHeights = _texelHeightBuffer.contents;
    texelHeights[0] = _texelHeight;
}

- (void)setEdgeStrength:(float)edgeStrength {
    _edgeStrength = edgeStrength;
    float *edgeStrengths = _edgeStrengthBuffer.contents;
    edgeStrengths[0] = _edgeStrength;
}

- (void)setSecondVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setSecondVertexFragmentBufferOrTexture:commandEncoder];
    
    [commandEncoder setVertexBuffer:_texelWidthBuffer offset:0 atIndex:2];
    [commandEncoder setVertexBuffer:_texelHeightBuffer offset:0 atIndex:3];
    [commandEncoder setFragmentBuffer:_edgeStrengthBuffer offset:0 atIndex:0];
}


+ (NSString *)fragmentShaderFunction {
    NSString *function = @"MILuminanceFragmentShader";
    return function;
}

+ (NSString *)secondVertexShaderFunction {
    NSString *function = @"MINearbyTexelSamplingVertexShader";
    return function;
}

+ (NSString *)secondFragmentShaderFunction {
    NSString *fFunction = @"MISobelEdgeDetectionFragmentShader";
    return fFunction;
}

@end
