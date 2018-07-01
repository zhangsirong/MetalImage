//
//  MIFalseColorFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFalseColorFilter.h"

@implementation MIFalseColorFilter

- (instancetype)init {
    if (self = [super init]) {
        
        _firstColorBuffer = [MIContext createBufferWithLength:sizeof(vector_float3)];
        _secondColorBuffer = [MIContext createBufferWithLength:sizeof(vector_float3)];
        self.firstColor = vector4(0.0f, 0.0f, 0.5f, 1.0f);
        self.secondColor = vector4(1.0f, 0.0f, 0.0f, 1.0f);
    }
    return self;
}

- (void)setFirstColor:(vector_float4)firstColor {
    _firstColor = firstColor;
    vector_float3 *firstColors = _firstColorBuffer.contents;
    firstColors[0] = _firstColor.xyz;
}

- (void)setFirstColorRed:(float)redComponent green:(float)greenComponent blue:(float)blueComponent {
    self.firstColor = vector4(redComponent, greenComponent, blueComponent, 1.0f);
}

- (void)setSecondColor:(vector_float4)secondColor
{
    _secondColor = secondColor;
    vector_float3 *secondColors = _secondColorBuffer.contents;
    secondColors[0] = _secondColor.xyz;
}

- (void)setSecondColorRed:(float)redComponent green:(float)greenComponent blue:(float)blueComponent {
    self.secondColor = vector4(redComponent, greenComponent, blueComponent, 1.0f);
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_firstColorBuffer offset:0 atIndex:0];
    [commandEncoder setFragmentBuffer:_secondColorBuffer offset:0 atIndex:1];
}

+ (NSString *)fragmentShaderFunction {
    NSString *funciton = @"MIFalseColorFragmentShader";
    return funciton;
}


@end
