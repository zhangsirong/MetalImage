//
//  MIPolarPixellateFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIPolarPixellateFilter.h"

@interface MIPolarPixellateFilter ()
{
    id<MTLBuffer> _centerBuffer;
    id<MTLBuffer> _pixelSizeBuffer;
}
@end

@implementation MIPolarPixellateFilter

- (instancetype)init {
    if (self = [super init]) {
        _centerBuffer = [[MIContext sharedContext].device newBufferWithLength:sizeof(vector_float2) options:MTLResourceOptionCPUCacheModeDefault];
        
        _pixelSizeBuffer = [[MIContext sharedContext].device newBufferWithLength:sizeof(vector_float2) options:MTLResourceOptionCPUCacheModeDefault];
        
        self.pixelSize = CGSizeMake(0.05, 0.05);
        self.center = CGPointMake(0.5, 0.5);
    }
    return self;
}

- (void)setCenter:(CGPoint)center {
    _center = center;
    float centerX = center.x;
    float centerY = center.y;
    vector_float2 *centers = _centerBuffer.contents;
    centers[0] = vector2(centerX, centerY);
}

- (void)setPixelSize:(CGSize)pixelSize {
    _pixelSize = pixelSize;
    float width = pixelSize.width;
    float height = pixelSize.height;
    vector_float2 *centers = _pixelSizeBuffer.contents;
    centers[0] = vector2(width, height);
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_centerBuffer offset:0 atIndex:1];
    [commandEncoder setFragmentBuffer:_pixelSizeBuffer offset:0 atIndex:2];
}

+ (NSString *)fragmentShaderFunction {
    static NSString *fFunction = @"MIPolarPixellateFragmentShader";
    return fFunction;
}

@end
