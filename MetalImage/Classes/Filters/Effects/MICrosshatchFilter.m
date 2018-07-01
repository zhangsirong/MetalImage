//
//  MICrosshatchFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MICrosshatchFilter.h"

@interface MICrosshatchFilter ()
{
    id<MTLBuffer> _crossHatchSpacingBuffer;
    id<MTLBuffer> _lineWidthBuffer;
}
@end

@implementation MICrosshatchFilter

- (instancetype)init {
    if (self = [super init]) {
        _crossHatchSpacingBuffer = [[MIContext sharedContext].device newBufferWithLength:sizeof(float) options:MTLResourceOptionCPUCacheModeDefault];
        
        _lineWidthBuffer = [[MIContext sharedContext].device newBufferWithLength:sizeof(float) options:MTLResourceOptionCPUCacheModeDefault];
        
        self.crossHatchSpacing = 0.03;
        self.lineWidth = 0.003;
    }
    return self;
}

- (void)setCrossHatchSpacing:(float)crossHatchSpacing {
    _crossHatchSpacing = crossHatchSpacing;
    float *crossHatchSpacings = _crossHatchSpacingBuffer.contents;
    crossHatchSpacings[0] = crossHatchSpacing;
    
}

- (void)setLineWidth:(float)lineWidth {
    _lineWidth = lineWidth;
    float *lineWidths = _lineWidthBuffer.contents;
    lineWidths[0] = lineWidth;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_crossHatchSpacingBuffer offset:0 atIndex:1];
    [commandEncoder setFragmentBuffer:_lineWidthBuffer offset:0 atIndex:2];
}

+ (NSString *)fragmentShaderFunction {
    static NSString *fFunction = @"MICrosshatchFragmentShader";
    return fFunction;
}

@end
