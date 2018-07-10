//
//  MICropFilter.m
//  MetalImage
//
//  Created by zsr on 2018/07/09.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MICropFilter.h"

@interface MICropFilter() {
    id<MTLBuffer> _cropTextureCoordinatesBuffer;
    MITextureOrientation _preTextureOrientation;
}

@end@implementation MICropFilter

- (instancetype)init {
    return [self initWithCropRegion:CGRectMake(0, 0, 1, 1)];
}

- (instancetype)initWithCropRegion:(CGRect)newCropRegion {
    if (self = [super init]) {
        _preTextureOrientation = MITextureOrientationUp;
        _cropTextureCoordinatesBuffer = [MIContext createBufferWithLength:4 * sizeof(vector_float2)];
        self.cropRegion = newCropRegion;
    }
    return self;
}

- (void)setCropRegion:(CGRect)cropRegion {
    _cropRegion = cropRegion;
    [self calculateCropTextureCoordinates];
    self.contentSize = CGSizeZero;
}

- (void)calculateCropTextureCoordinates {
    float minX = _cropRegion.origin.x;
    float minY = _cropRegion.origin.y;
    float maxX = CGRectGetMaxX(_cropRegion);
    float maxY = CGRectGetMaxY(_cropRegion);
    
    MITextureOrientation orientation = MITextureOrientationUp;
    if (_inputTexture) {
        orientation = _inputTexture.orientation;
    }
    
    vector_float2 *cropTextureCoordinates = _cropTextureCoordinatesBuffer.contents;
    
    switch (orientation) {
        case MITextureOrientationUp:
            cropTextureCoordinates[0] = vector2(minX, maxY);   // 0, 1
            cropTextureCoordinates[1] = vector2(maxX, maxY);   // 1, 1
            cropTextureCoordinates[2] = vector2(minX, minY);   // 0, 0
            cropTextureCoordinates[3] = vector2(maxX, minY);   // 1, 0
            break;
            
        case MITextureOrientationDown:
            cropTextureCoordinates[0] = vector2(maxX, minY);   // 1, 0
            cropTextureCoordinates[1] = vector2(minX, minY);   // 0, 0
            cropTextureCoordinates[2] = vector2(maxX, maxY);   // 1, 1
            cropTextureCoordinates[3] = vector2(minX, maxY);   // 0, 1
            break;
            
        case MITextureOrientationLeft:
            cropTextureCoordinates[0] = vector2(minY, 1.0f - maxX);   // 0, 0
            cropTextureCoordinates[1] = vector2(minY, 1.0f - minX);   // 0, 1
            cropTextureCoordinates[2] = vector2(maxY, 1.0f - maxX);   // 1, 0
            cropTextureCoordinates[3] = vector2(maxY, 1.0f - minX);   // 1, 1
            break;
            
        case MITextureOrientationRight:
            cropTextureCoordinates[0] = vector2(maxY, 1.0f - minX);   // 1, 1
            cropTextureCoordinates[1] = vector2(maxY, 1.0f - maxX);   // 1, 0
            cropTextureCoordinates[2] = vector2(minY, 1.0f - minX);   // 0, 1
            cropTextureCoordinates[3] = vector2(minY, 1.0f - maxX);   // 0, 0
            break;
            
        case MITextureOrientationUpMirrored:
            cropTextureCoordinates[0] = vector2(maxX, maxY);   // 1, 1
            cropTextureCoordinates[1] = vector2(minX, maxY);   // 0, 1
            cropTextureCoordinates[2] = vector2(maxX, minY);   // 1, 0
            cropTextureCoordinates[3] = vector2(minX, minY);   // 0, 0
            break;
            
        case MITextureOrientationDownMirrored:
            cropTextureCoordinates[0] = vector2(minX, minY);   // 0, 0
            cropTextureCoordinates[1] = vector2(maxX, minY);   // 1, 0
            cropTextureCoordinates[2] = vector2(minX, maxY);   // 0, 1
            cropTextureCoordinates[3] = vector2(maxX, maxY);   // 1, 1
            break;
            
        case MITextureOrientationLeftMirrored:
            cropTextureCoordinates[0] = vector2(maxY, 1.0f - maxX);   // 1, 0
            cropTextureCoordinates[1] = vector2(maxY, 1.0f - minX);   // 1, 1
            cropTextureCoordinates[2] = vector2(minY, 1.0f - maxX);   // 0, 0
            cropTextureCoordinates[3] = vector2(minY, 1.0f - minX);   // 0, 1
            break;
            
        case MITextureOrientationRightMirrored:
            cropTextureCoordinates[0] = vector2(minY, 1.0f - minX);   // 0, 1
            cropTextureCoordinates[1] = vector2(minY, 1.0f - maxX);   // 0, 0
            cropTextureCoordinates[2] = vector2(maxY, 1.0f - minX);   // 1, 1
            cropTextureCoordinates[3] = vector2(maxY, 1.0f - maxX);   // 1, 0
            break;
    }
}

- (void)renderRect:(CGRect)rect atTime:(CMTime)time commandBuffer:(id<MTLCommandBuffer>)commandBuffer {
    if (!_inputTexture || !self.isEnabled) {
        return;
    }
    
    if (CGSizeEqualToSize(CGSizeZero, self.contentSize)) {
        self.contentSize = CGSizeMake(_inputTexture.size.width * _cropRegion.size.width, _inputTexture.size.height * _cropRegion.size.height);
    }
    
    if (CGRectEqualToRect(self.outputFrame, CGRectZero)) {
        self.outputFrame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    }
    
    if (!CGSizeEqualToSize(self.contentSize, _outputTexture.size)) {
        [_outputTexture setupContentWithSize:self.contentSize];
    }
    
    if (!CGRectEqualToRect(_preRenderRect, rect)) {
        _preRenderRect = rect;
        [MIContext updateBufferContent:_positionBuffer contentSize:self.contentSize outputFrame:CGRectZero];
    }
    
    _renderPassDescriptor.colorAttachments[0].texture = _outputTexture.mtlTexture;;
    
    id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:_renderPassDescriptor];
    [commandEncoder setRenderPipelineState:_renderPipelineState];
    
    [commandEncoder setVertexBuffer:_positionBuffer offset:0 atIndex:0];
    [commandEncoder setVertexBuffer:_cropTextureCoordinatesBuffer offset:0 atIndex:1];

    [commandEncoder setFragmentTexture:_inputTexture.mtlTexture atIndex:0];
    
    [commandEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip vertexStart:0 vertexCount:4];
    [commandEncoder endEncoding];

    [self produceAtTime:time commandBuffer:commandBuffer];
}

@end
