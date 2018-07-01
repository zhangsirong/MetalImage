//
//  MI3x3ConvolutionFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MI3x3ConvolutionFilter.h"

@implementation MI3x3ConvolutionFilter

- (instancetype)init {
    if (self = [super init]) {
        _convolutionKernelBuffer = [MIContext createBufferWithLength:sizeof(matrix_float3x3)];
        
        self.convolutionKernel = simd_matrix(vector3(0.0f, 0.0f, 0.0f),
                                             vector3(0.0f, 1.0f, 0.0f),
                                             vector3(0.0f, 0.0f, 0.0f));
    }
    return self;
}

- (void)setConvolutionKernel:(matrix_float3x3)convolutionKernel {
    _convolutionKernel = convolutionKernel;
    
    matrix_float3x3 *convolutionKernels = _convolutionKernelBuffer.contents;
    convolutionKernels[0] = _convolutionKernel;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_convolutionKernelBuffer offset:0 atIndex:0];
}

+ (NSString *)fragmentShaderFunction {
    NSString *function = @"MI3x3ConvolutionFragmentShader";
    return function;
}
@end
