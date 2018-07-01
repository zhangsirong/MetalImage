//
//  MIKuwaharaFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIKuwaharaFilter.h"

@implementation MIKuwaharaFilter

- (instancetype)init {
    if (self = [super init]) {
        _radiusBuffer = [MIContext createBufferWithLength:sizeof(int)];
        
        self.radius = 3;
    }
    return self;
}

- (void)setRadius:(int)radius {
    _radius = radius;
    
    int *radiuss = _radiusBuffer.contents;
    radiuss[0] = radius;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_radiusBuffer offset:0 atIndex:0];
}

+ (NSString *)fragmentShaderFunction {
    NSString *funciton = @"MIKuwaharaFragmentShader";
    return funciton;
}

@end
