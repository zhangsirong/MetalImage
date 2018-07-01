//
//  MIHueFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIHueFilter.h"

@implementation MIHueFilter

- (instancetype)init {
    if (self = [super init]) {
        
        _hueAdjustBuffer = [MIContext createBufferWithLength:sizeof(float)];
        self.hue = 90.0;
    }
    return self;
}

- (void)setHue:(float)hue {
    // Convert degrees to radians for hue rotation
    _hue = fmodf(hue, 360.0) * M_PI/180;
    
    float *hues = _hueAdjustBuffer.contents;
    
    hues[0] = _hue;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_hueAdjustBuffer offset:0 atIndex:0];
}

+ (NSString *)fragmentShaderFunction {
    NSString *funciton = @"MIHueFragmentShader";
    return funciton;
}
@end
