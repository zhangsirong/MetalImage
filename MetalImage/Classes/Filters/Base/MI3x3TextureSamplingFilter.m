//
//  MI3x3TextureSamplingFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MI3x3TextureSamplingFilter.h"

@implementation MI3x3TextureSamplingFilter

- (instancetype)init {
    if (self = [super init]) {
        _texelWidthBuffer = [MIContext createBufferWithLength:sizeof(float)];
        _texelHeightBuffer = [MIContext createBufferWithLength:sizeof(float)];
        
        self.texelWidth = 1.0 / 750;
        self.texelHeight = 1.0 / 1000;
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

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    
    [commandEncoder setVertexBuffer:_texelWidthBuffer offset:0 atIndex:2];
    [commandEncoder setVertexBuffer:_texelHeightBuffer offset:0 atIndex:3];
}

+ (NSString *)vertexShaderFunction {
    NSString *function = @"MINearbyTexelSamplingVertexShader";
    return function;
}

@end
