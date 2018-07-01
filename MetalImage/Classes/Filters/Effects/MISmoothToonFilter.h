//
//  MISmoothToonFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilterGroup.h"
@class MIGaussianBlurFilter;
@class MIToonFilter;

@interface MISmoothToonFilter : MIFilterGroup
{
    MIGaussianBlurFilter *_blurFilter;
    MIToonFilter *_toonFilter;
}

/// The image width and height factors tweak the appearance of the edges. By default, they match the filter size in pixels
@property (nonatomic) CGFloat texelWidth;
/// The image width and height factors tweak the appearance of the edges. By default, they match the filter size in pixels
@property (nonatomic) CGFloat texelHeight;

/// The radius of the underlying Gaussian blur. The default is 2.0.
@property  (nonatomic) CGFloat blurRadiusInPixels;

/// The threshold at which to apply the edges, default of 0.2
@property (nonatomic) CGFloat threshold;

/// The levels of quantization for the posterization of colors within the scene, with a default of 10.0
@property (nonatomic) CGFloat quantizationLevels;

@end
