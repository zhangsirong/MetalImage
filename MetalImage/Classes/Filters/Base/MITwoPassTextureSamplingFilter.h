//
//  MITwoPassTextureSamplingFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MITwoPassFilter.h"

@interface MITwoPassTextureSamplingFilter : MITwoPassFilter
{
    id<MTLBuffer> _verticalPassTexelWidthOffsetBuffer;
    id<MTLBuffer> _verticalPassTexelHeightOffsetBuffer;
    id<MTLBuffer> _horizontalPassTexelWidthOffsetBuffer;
    id<MTLBuffer> _horizontalPassTexelHeightOffsetBuffer;
    float _verticalTexelSpacing;
    float _horizontalTexelSpacing;
    
}

// This sets the spacing between texels (in pixels) when sampling for the first. By default, this is 1.0
@property (nonatomic) float verticalTexelSpacing;
@property (nonatomic) float horizontalTexelSpacing;

- (void)setupFilterForSize:(CGSize)filterFrameSize;

@end
