//
//  MIColorMatrixFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

@interface MIColorMatrixFilter : MIFilter
{
    id<MTLBuffer> _colorMatrixBuffer;
    id<MTLBuffer> _intensityBuffer;
}

/** A 4x4 matrix used to transform each color in an image
 */
@property (nonatomic) matrix_float4x4 colorMatrix;

/** The degree to which the new transformed color replaces the original color for each pixel
 */
@property (nonatomic) float intensity;


@end
