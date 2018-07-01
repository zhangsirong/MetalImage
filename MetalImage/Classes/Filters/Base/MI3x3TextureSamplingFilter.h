//
//  MI3x3TextureSamplingFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

@interface MI3x3TextureSamplingFilter : MIFilter
{
    id<MTLBuffer> _texelWidthBuffer;
    id<MTLBuffer> _texelHeightBuffer;
}
// The texel width and height factors tweak the appearance of the edges. By default, they match the inverse of the filter size in pixels
@property (nonatomic) float texelWidth;
@property (nonatomic) float texelHeight;

@end
