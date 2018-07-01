//
//  MIPosterizeFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIPosterizeFilter.h"

@implementation MIPosterizeFilter

- (instancetype)init {
    if (self = [super init]) {
        _colorLevelsBuffer = [MIContext createBufferWithLength:sizeof(int)];
        self.colorLevels = 10;
    }
    return self;
}

- (void)setColorLevels:(int)colorLevels {
    _colorLevels = simd_clamp(colorLevels, 1.0, 256.0);
    
    int *colorLevelss = _colorLevelsBuffer.contents;
    colorLevelss[0] = _colorLevels;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_colorLevelsBuffer offset:0 atIndex:0];
}

+ (NSString *)fragmentShaderFunction {
    NSString *funciton = @"MIPosterizeFragmentShader";
    return funciton;
}

@end
