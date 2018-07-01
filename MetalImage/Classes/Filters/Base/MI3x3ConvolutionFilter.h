//
//  MI3x3ConvolutionFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MI3x3TextureSamplingFilter.h"

@interface MI3x3ConvolutionFilter : MI3x3TextureSamplingFilter
{
    id<MTLBuffer> _convolutionKernelBuffer;
}

@property (nonatomic) matrix_float3x3 convolutionKernel;

@end
