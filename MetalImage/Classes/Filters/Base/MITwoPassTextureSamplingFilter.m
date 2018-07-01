//
//  MITwoPassTextureSamplingFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MITwoPassTextureSamplingFilter.h"

@implementation MITwoPassTextureSamplingFilter

- (instancetype)init {
    if (self = [super init]) {
        _verticalPassTexelWidthOffsetBuffer = [MIContext createBufferWithLength:sizeof(float)];
        _verticalPassTexelHeightOffsetBuffer = [MIContext createBufferWithLength:sizeof(float)];
        _horizontalPassTexelWidthOffsetBuffer = [MIContext createBufferWithLength:sizeof(float)];
        _horizontalPassTexelHeightOffsetBuffer = [MIContext createBufferWithLength:sizeof(float)];
        
        self.verticalTexelSpacing = 1.0;
        self.horizontalTexelSpacing = 1.0;
    }
    return self;
}

- (void)setHorizontalTexelSpacing:(float)horizontalTexelSpacing {
    _horizontalTexelSpacing = horizontalTexelSpacing;
    [self setupFilterForSize:CGSizeMake(750, 1000)];
}

- (void)setVerticalTexelSpacing:(float)verticalTexelSpacing {
    _verticalTexelSpacing = verticalTexelSpacing;
    [self setupFilterForSize:CGSizeMake(750, 1000)];
}

- (void)setContentSize:(CGSize)contentSize {
    [super setContentSize:contentSize];
    [self setupFilterForSize:contentSize];
}

- (void)setupFilterForSize:(CGSize)filterFrameSize {
    float *verticalPassTexelWidthOffsets = _verticalPassTexelWidthOffsetBuffer.contents;
    verticalPassTexelWidthOffsets[0] = 0;
    
    float *verticalPassTexelHeightOffsets = _verticalPassTexelHeightOffsetBuffer.contents;
    verticalPassTexelHeightOffsets[0] = _verticalTexelSpacing / filterFrameSize.height;
    
    float *horizontalPassTexelWidthOffsets = _horizontalPassTexelWidthOffsetBuffer.contents;
    horizontalPassTexelWidthOffsets[0] = _horizontalTexelSpacing / filterFrameSize.width;
    
    float *horizontalPassTexelHeightOffsets = _horizontalPassTexelHeightOffsetBuffer.contents;
    horizontalPassTexelHeightOffsets[0] = 0;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setVertexBuffer:_verticalPassTexelWidthOffsetBuffer offset:0 atIndex:2];
    [commandEncoder setVertexBuffer:_verticalPassTexelHeightOffsetBuffer offset:0 atIndex:3];
}

- (void)setSecondVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setSecondVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setVertexBuffer:_horizontalPassTexelWidthOffsetBuffer offset:0 atIndex:2];
    [commandEncoder setVertexBuffer:_horizontalPassTexelHeightOffsetBuffer offset:0 atIndex:3];
}

@end
