//
//  MIBrightnessFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIBrightnessFilter.h"

@implementation MIBrightnessFilter

- (instancetype)init {
    if (self = [super init]) {
        
        _brightnessBuffer = [MIContext createBufferWithLength:sizeof(float)];
        self.brightness = 0.0;
    }
    return self;
}

- (void)setBrightness:(float)brightness {
    _brightness = brightness;
    
    float *brightnesss = _brightnessBuffer.contents;
    brightnesss[0] = _brightness;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_brightnessBuffer offset:0 atIndex:0];
}

+ (NSString *)fragmentShaderFunction {
    NSString *funciton = @"MIBrightnessFragmentShader";
    return funciton;
}


@end
