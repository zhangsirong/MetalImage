//
//  MIVignetteFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

@interface MIVignetteFilter : MIFilter
{
    id<MTLBuffer> _vignetteCenterBuffer;
    id<MTLBuffer> _vignetteColorBuffer;
    id<MTLBuffer> _vignetteStartBuffer;
    id<MTLBuffer> _vignetteEndBuffer;
}

// the center for the vignette in tex coords (defaults to 0.5, 0.5)
@property (nonatomic, readwrite) CGPoint vignetteCenter;

// The color to use for the Vignette (defaults to black)
@property (nonatomic, readwrite) vector_float3 vignetteColor;

// The normalized distance from the center where the vignette effect starts. Default of 0.5.
@property (nonatomic, readwrite) float vignetteStart;

// The normalized distance from the center where the vignette effect ends. Default of 0.75.
@property (nonatomic, readwrite) float vignetteEnd;


@end
