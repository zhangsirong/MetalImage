//
//  MITwoPassFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//


#import "MITwoPassFilter.h"

@implementation MITwoPassFilter

- (instancetype)init {
    if (self = [super init]) {
        _secondRenderPipelineState = [MIContext createRenderPipelineStateWithVertexFunction:[[self class] secondVertexShaderFunction] fragmentFunction:[[self class] secondFragmentShaderFunction]];
        _secondpassDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
    }
    return self;
}

- (void)renderRect:(CGRect)rect atTime:(CMTime)time commandBuffer:(id<MTLCommandBuffer>)commandBuffer {
    if (!_inputTexture || !self.isEnabled) {
        return;
    }
    
    if (CGSizeEqualToSize(CGSizeZero, self.contentSize)) {
        self.contentSize = _inputTexture.size;
    }
    
    if (CGRectEqualToRect(self.outputFrame, CGRectZero)) {
        self.outputFrame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    }
    
    if (!CGSizeEqualToSize(self.contentSize, _outputTexture.size)) {
        _firstOutputTexture = nil;
        _firstOutputTexture = [[MITexture alloc] initWithSize:self.contentSize];
    }
    
    if (!CGSizeEqualToSize(self.contentSize, _outputTexture.size)) {
        _outputTexture = nil;
        _outputTexture = [[MITexture alloc] initWithSize:self.contentSize];
    }
    
    if (!_positionBuffer ) {
        _positionBuffer = [MIContext createBufferWithLength:4 * sizeof(vector_float4)];
    }
    
    if (!CGRectEqualToRect(_preRenderRect,rect)) {
        _preRenderRect = rect;
        [MIContext updateBufferContent:_positionBuffer contentSize:self.contentSize outputFrame:rect];
    }
    
    id<MTLTexture> framebufferTexture = _firstOutputTexture.mtlTexture;
    
    _passDescriptor.colorAttachments[0].texture = framebufferTexture;
    _passDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 0.0);
    _passDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    _passDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    
    id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:_passDescriptor];
    [commandEncoder setRenderPipelineState:_renderPipelineState];
    [commandEncoder setViewport:(MTLViewport){0, 0, self.contentSize.width,self.contentSize.height, -1.0, 1.0}];
    
    [commandEncoder setVertexBuffer:_positionBuffer offset:0 atIndex:0];
    [commandEncoder setVertexBuffer:_inputTexture.textureCoordinateBuffer offset:0 atIndex:1];
    [commandEncoder setFragmentTexture:_inputTexture.mtlTexture atIndex:0];
    
    [self setVertexFragmentBufferOrTexture:commandEncoder];
    
    [commandEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip vertexStart:0 vertexCount:4];
    [commandEncoder endEncoding];
    
    [self renderSecondPassAtTime:time commandBuffer:commandBuffer];
}

- (void)renderSecondPassAtTime:(CMTime)time commandBuffer:(id<MTLCommandBuffer>)commandBuffer {
    id<MTLTexture> framebufferTexture = _outputTexture.mtlTexture;
    
    _secondpassDescriptor.colorAttachments[0].texture = framebufferTexture;
    _secondpassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 0.0);
    _secondpassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    _secondpassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    
    id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:_secondpassDescriptor];
    [commandEncoder setRenderPipelineState:_secondRenderPipelineState];
    [commandEncoder setViewport:(MTLViewport){0, 0, self.contentSize.width,self.contentSize.height, -1.0, 1.0}];
    
    [commandEncoder setVertexBuffer:_positionBuffer offset:0 atIndex:0];
    [commandEncoder setVertexBuffer:_inputTexture.textureCoordinateBuffer offset:0 atIndex:1];
    [commandEncoder setFragmentTexture:_firstOutputTexture.mtlTexture atIndex:0];
    
    [self setSecondVertexFragmentBufferOrTexture:commandEncoder];
    
    [commandEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip vertexStart:0 vertexCount:4];
    [commandEncoder endEncoding];
    
    [self produceAtTime:time commandBuffer:commandBuffer];
}

- (void)setSecondVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    
}

+ (NSString *)secondVertexShaderFunction {
    return [[self class] vertexShaderFunction];
}

+ (NSString *)secondFragmentShaderFunction {
    return [[self class] fragmentShaderFunction];
}

@end
