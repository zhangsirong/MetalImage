//
//  MIContrastFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIContrastFilter.h"

@implementation MIContrastFilter

- (instancetype)init {
    if (self = [super init]) {
        
        _contrastBuffer = [MIContext createBufferWithLength:sizeof(float)];
        self.contrast = 1.0;
    }
    return self;
}

- (void)setContrast:(float)contrast {
    _contrast = contrast;
    
    float *contrasts = _contrastBuffer.contents;
    contrasts[0] = _contrast;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_contrastBuffer offset:0 atIndex:0];
}

+ (NSString *)fragmentShaderFunction {
    NSString *funciton = @"MIContrastFragmentShader";
    return funciton;
}


@end
