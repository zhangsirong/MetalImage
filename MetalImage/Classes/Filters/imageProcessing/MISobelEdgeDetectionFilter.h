//
//  MISobelEdgeDetectionFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MITwoPassFilter.h"

@interface MISobelEdgeDetectionFilter : MITwoPassFilter
{
    id<MTLBuffer> _texelWidthBuffer;
    id<MTLBuffer> _texelHeightBuffer;
    id<MTLBuffer> _edgeStrengthBuffer;
}
// The texel width and height factors tweak the appearance of the edges. By default, they match the inverse of the filter size in pixels
@property (nonatomic) float texelWidth;
@property (nonatomic) float texelHeight;

// The filter strength property affects the dynamic range of the filter. High values can make edges more visible, but can lead to saturation. Default of 1.0.
@property (nonatomic) float edgeStrength;

@end

