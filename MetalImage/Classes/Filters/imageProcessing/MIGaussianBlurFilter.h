//
//  MIGaussianBlurFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MITwoPassTextureSamplingFilter.h"

/**
 高斯模糊 blurRadiusInPixels最大支持7个，后续做超过大于7个的
 */
@interface MIGaussianBlurFilter : MITwoPassTextureSamplingFilter
{
    float _blurRadiusInPixels;
    BOOL _shouldResizeBlurRadiusWithImageSize;
    
    id<MTLBuffer> _blurCountBuffer;
    id<MTLBuffer> _offsetFromCenterBuffer;
    id<MTLBuffer> _optimizedWeightBuffer;
}

/** A multiplier for the spacing between texels, ranging from 0.0 on up, with a default of 1.0. Adjusting this may slightly increase the blur strength, but will introduce artifacts in the result.
 */
@property  (nonatomic) float texelSpacingMultiplier;

/** A radius in pixels to use for the blur, with a default of 2.0. This adjusts the sigma variable in the Gaussian distribution function.
 */
@property  (nonatomic) float blurRadiusInPixels;

/** Setting these properties will allow the blur radius to scale with the size of the image. These properties are mutually exclusive; setting either will set the other to 0.
 */
@property  (nonatomic) float blurRadiusAsFractionOfImageWidth;
@property  (nonatomic) float blurRadiusAsFractionOfImageHeight;

/// The number of times to sequentially blur the incoming image. The more passes, the slower the filter.
@property (nonatomic) NSUInteger blurPasses;

@end
