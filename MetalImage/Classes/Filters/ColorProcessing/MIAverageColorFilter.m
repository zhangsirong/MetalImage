//
//  MIAverageColorFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIAverageColorFilter.h"
@interface MIAverageColorFilter ()
{
    MITexture *_texture1;
    MITexture *_texture2;
    MITexture *_texture3;
    MITexture *_texture4;
}

@end

@implementation MIAverageColorFilter

- (instancetype)init
{
    if (self = [super init]) {
        _texelWidthBuffer = [MIContext createBufferWithLength:sizeof(float)];
        _texelHeightBuffer = [MIContext createBufferWithLength:sizeof(float)];
        _finalStageSize = CGSizeMake(1.0, 1.0);
    }
    return self;
}

- (void)renderRect:(CGRect)rect atTime:(CMTime)time commandBuffer:(id<MTLCommandBuffer>)commandBuffer
{
    if (!_inputTexture || !self.isEnabled) {
        return;
    }
    
    if (CGSizeEqualToSize(CGSizeZero, self.contentSize)) {
        self.contentSize = _inputTexture.size;
    }
    
    if (CGRectEqualToRect(self.outputFrame, CGRectZero)) {
        self.outputFrame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    }
    
    if (!_outputTexture || !CGSizeEqualToSize(self.contentSize, _outputTexture.size)) {
        _outputTexture = [[MITexture alloc] initWithSize:self.contentSize];
    }
    
    if (!_positionBuffer ) {
        _positionBuffer = [MIContext createBufferWithLength:4 * sizeof(vector_float4)];
    }
    
    if (!CGRectEqualToRect(_preRenderRect,rect)) {
        _preRenderRect = rect;
        [MIContext updateBufferContent:_positionBuffer contentSize:self.contentSize outputFrame:rect];
    }
    
    if (!_texture1) {
        _texture1 = [[MITexture alloc] initWithSize:CGSizeMake(160, 213)];
        _texture2 = [[MITexture alloc] initWithSize:CGSizeMake(40, 53)];
        _texture3 = [[MITexture alloc] initWithSize:CGSizeMake(10, 13)];
        _texture4 = [[MITexture alloc] initWithSize:CGSizeMake(2, 3)];
    }
    _finalStageSize = CGSizeMake(160, 213);
    [self processOutputTexture:_texture1 inputTexture:_inputTexture commandBuffer:commandBuffer];
    _finalStageSize = CGSizeMake(40, 53);
    
    [self processOutputTexture:_texture2 inputTexture:_texture1 commandBuffer:commandBuffer];
    _finalStageSize = CGSizeMake(10, 13);
    
    [self processOutputTexture:_texture3 inputTexture:_texture2 commandBuffer:commandBuffer];
    _finalStageSize = CGSizeMake(2, 3);
    
    [self processOutputTexture:_texture4 inputTexture:_texture3 commandBuffer:commandBuffer];
    
    _finalStageSize = CGSizeMake(1, 1);
    [self processOutputTexture:_outputTexture inputTexture:_texture4 commandBuffer:commandBuffer];
    
//    id<MTLTexture> framebufferTexture = _texture1.mtlTexture;
//
//    MTLRenderPassDescriptor *passDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
//    passDescriptor.colorAttachments[0].texture = framebufferTexture;
//    passDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 0.0);
//    passDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
//    passDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
//
//    id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:passDescriptor];
//    [commandEncoder setRenderPipelineState:_pipeline];
//    [commandEncoder setVertexBuffer:_positionBuffer offset:0 atIndex:0];
//    [commandEncoder setVertexBuffer:_inputTexture.textureCoordinateBuffer offset:0 atIndex:1];
//    [commandEncoder setFragmentTexture:_inputTexture.mtlTexture atIndex:0];
//
//    [self setVertexFragmentBufferOrTexture:commandEncoder];
//
//    [commandEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip vertexStart:0 vertexCount:4];
//    [commandEncoder endEncoding];
    
    [self produceAtTime:time commandBuffer:commandBuffer];
}

- (void)processOutputTexture:(MITexture *)outputTexture
                inputTexture:(MITexture *)inputTexture
               commandBuffer:(id<MTLCommandBuffer>)commandBuffer
{
    id<MTLTexture> framebufferTexture = outputTexture.mtlTexture;
    
    _renderPassDescriptor.colorAttachments[0].texture = framebufferTexture;
    
    id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:_renderPassDescriptor];
    [commandEncoder setRenderPipelineState:_renderPipelineState];
    [commandEncoder setViewport:(MTLViewport){0, 0, self.contentSize.width,self.contentSize.height, 0.0, 1.0}];
    [commandEncoder setVertexBuffer:_positionBuffer offset:0 atIndex:0];
    [commandEncoder setVertexBuffer:inputTexture.textureCoordinateBuffer offset:0 atIndex:1];
    [commandEncoder setFragmentTexture:inputTexture.mtlTexture atIndex:0];
    
    [self setVertexFragmentBufferOrTexture:commandEncoder];
    
    [commandEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip vertexStart:0 vertexCount:4];
    [commandEncoder endEncoding];
}


- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder
{
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    
    float *texelWidths = _texelWidthBuffer.contents;
    texelWidths[0] = 0.25 / _finalStageSize.width;
    
    float *texelHeights = _texelHeightBuffer.contents;
    texelHeights[0] = 0.25 / _finalStageSize.height;
    
    [commandEncoder setVertexBuffer:_texelWidthBuffer offset:0 atIndex:2];
    [commandEncoder setVertexBuffer:_texelHeightBuffer offset:0 atIndex:3];
}

+ (NSString *)vertexShaderFunction
{
    NSString *function = @"MIColorAverageVertexShader";
    return function;
}

+ (NSString *)fragmentShaderFunction
{
    NSString *function = @"MIColorAverageFragmentShader";
    return function;
}



@end
