//
//  MIFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

@implementation MIFilter

- (instancetype)init {
    
    if (self = [super init]) {
        _renderPipelineState = [MIContext createRenderPipelineStateWithVertexFunction:[[self class] vertexShaderFunction]
                                                                     fragmentFunction:[[self class] fragmentShaderFunction]];
        _passDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
    }
    return self;
}

- (instancetype)initWithContentSize:(CGSize)contentSize {
    if (self = [self init]) {
        self.contentSize = contentSize;
    }
    return self;
}

- (void)setInputTexture:(MITexture *)inputTexture {
    _inputTexture = inputTexture;
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
    
    if (!_outputTexture || !CGSizeEqualToSize(self.contentSize, _outputTexture.size)) {
        _outputTexture = [[MITexture alloc] initWithSize:self.contentSize];
    }
    
    if (!_positionBuffer ) {
        _positionBuffer = [MIContext createBufferWithLength:4 * sizeof(vector_float4)];
    }
    
    if (!CGRectEqualToRect(_preRenderRect, rect)) {
        _preRenderRect = rect;
        [MIContext updateBufferContent:_positionBuffer contentSize:self.contentSize outputFrame:rect];
    }
    
    id<MTLTexture> framebufferTexture = _outputTexture.mtlTexture;
    _passDescriptor.colorAttachments[0].texture = framebufferTexture;
    _passDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 0.0);
    _passDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    _passDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;

    id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:_passDescriptor];
    [commandEncoder setRenderPipelineState:_renderPipelineState];
    [commandEncoder setViewport:(MTLViewport){0, 0, self.contentSize.width,self.contentSize.height, 0.0, 1.0}];

    [commandEncoder setVertexBuffer:_positionBuffer offset:0 atIndex:0];
    [commandEncoder setVertexBuffer:_inputTexture.textureCoordinateBuffer offset:0 atIndex:1];

    [commandEncoder setFragmentTexture:_inputTexture.mtlTexture atIndex:0];

    [self setVertexFragmentBufferOrTexture:commandEncoder];

    [commandEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip vertexStart:0 vertexCount:4];
    [commandEncoder endEncoding];

    [self produceAtTime:time commandBuffer:commandBuffer];
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    
}

+ (NSString *)vertexShaderFunction {
    static NSString *vFunction = @"MIDefaultVertexShader";
    return vFunction;
}

+ (NSString *)fragmentShaderFunction {
    static NSString *fFunction = @"MIDefaultFragmentShader";
    return fFunction;
}

- (UIImage *)imageFromCurrentFrame {
    __block UIImage *image;
    [MIContext performSynchronouslyOnImageProcessingQueue:^{
        image = [_outputTexture imageFromMTLTexture];
    }];
    
    return image;
}


@end
