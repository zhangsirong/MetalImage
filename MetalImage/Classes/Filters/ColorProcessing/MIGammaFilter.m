//
//  MIGammaFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIGammaFilter.h"

@implementation MIGammaFilter

- (instancetype)init {
    if (self = [super init]) {
        
        _gammaBuffer = [MIContext createBufferWithLength:sizeof(float)];
        self.gamma = 1.0;
    }
    return self;
}

- (void)setGamma:(float)gamma {
    _gamma = gamma;
    
    float *gammas = _gammaBuffer.contents;
    gammas[0] = _gamma;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_gammaBuffer offset:0 atIndex:0];
}

+ (NSString *)fragmentShaderFunction {
    NSString *funciton = @"MIGammaFragmentShader";
    return funciton;
}


@end

