//
//  MITwoInputFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MITwoInputFilter.h"

@implementation MITwoInputFilter

- (void)setInputTexture:(MITexture *)inputTexture {
    if (!_inputTexture) {
        _inputTexture = inputTexture;
    } else if (!_secondInputTexture) {
        _secondInputTexture = inputTexture;
    }
}

- (void)renderRect:(CGRect)rect atTime:(CMTime)time commandBuffer:(id<MTLCommandBuffer>)commandBuffer {
    if (!_inputTexture || !_secondInputTexture) {
        return;
    }
    [commandBuffer addCompletedHandler:^(id<MTLCommandBuffer> commandBuffer) {
        _inputTexture = nil;
        _secondInputTexture = nil;
    }];
    
    [self produceAtTime:time commandBuffer:commandBuffer];
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setVertexBuffer:_secondInputTexture.textureCoordinateBuffer offset:0 atIndex:2];
    [commandEncoder setFragmentTexture:_secondInputTexture.mtlTexture atIndex:1];
}

+ (NSString *)vertexShaderFunction {
    static NSString *vFunction = @"MITwoInputVertexShader";
    return vFunction;
}

+ (NSString *)fragmentShaderFunction {
    static NSString *fFunction = @"MITwoInputFragmentShader";
    return fFunction;
}

@end
