//
//  MISaturationFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MISaturationFilter.h"

@implementation MISaturationFilter

- (instancetype)init {
    if (self = [super init]) {
        _saturationBuffer = [MIContext createBufferWithLength:sizeof(float)];
        self.saturation = 1.0;
    }
    return self;
}

- (void)setSaturation:(float)saturation {
    _saturation = saturation;
    
    float *saturations = _saturationBuffer.contents;
    saturations[0] = _saturation;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_saturationBuffer offset:0 atIndex:0];
}

+ (NSString *)fragmentShaderFunction {
    NSString *funciton = @"MISaturationFragmentShader";
    return funciton;
}


@end

