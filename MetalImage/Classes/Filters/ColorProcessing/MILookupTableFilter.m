//
//  MILookupTableFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MILookupTableFilter.h"

@interface MILookupTableFilter ()
{
    MITexture *_tableTexture;
    id<MTLBuffer> _intensityBuffer;
}

@end

@implementation MILookupTableFilter

- (instancetype)init {
    if (self = [super init]) {
        _intensityBuffer = [MIContext createBufferWithLength:sizeof(float)];
        self.intensity = 1.0;
    }
    return self;
}

- (void)updateLookupTableImage:(UIImage *)table
{
    _tableTexture = nil;
    if(NULL != table.CGImage) {
        _tableTexture = [[MITexture alloc] initWithUIImage:table];
    }
}

- (void)setIntensity:(float)intensity {
    _intensity = intensity;
    float *intensitys = _intensityBuffer.contents;
    intensitys[0] = intensity;
}

- (void)renderRect:(CGRect)rect atTime:(CMTime)time commandBuffer:(id<MTLCommandBuffer>)commandBuffer {
    
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
    
    if (!_tableTexture) {
        _outputTexture = _inputTexture;
        [self produceAtTime:time commandBuffer:commandBuffer];
        return;
    }
    
    [super renderRect:rect atTime:time commandBuffer:commandBuffer];
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setVertexBuffer:_tableTexture.textureCoordinateBuffer offset:0 atIndex:1];

    [commandEncoder setFragmentTexture:_tableTexture.mtlTexture atIndex:1];
    [commandEncoder setFragmentBuffer:_intensityBuffer offset:0 atIndex:0];
}

+ (NSString *)vertexShaderFunction {
    static NSString *fFunction = @"MITwoInputVertexShader";
    return fFunction;
}

+ (NSString *)fragmentShaderFunction {
    static NSString *fFunction = @"MILookupTableFragmentShader";
    return fFunction;
}

@end
