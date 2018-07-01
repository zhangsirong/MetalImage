//
//  MIToonFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MI3x3TextureSamplingFilter.h"

@interface MIToonFilter : MI3x3TextureSamplingFilter
{
    id<MTLBuffer> _thresholdBuffer;
    id<MTLBuffer> _quantizationLevelsBuffer;
}

/** The threshold at which to apply the edges, default of 0.2
 */
@property (nonatomic) float threshold;

/** The levels of quantization for the posterization of colors within the scene, with a default of 10.0
 */
@property (nonatomic) float quantizationLevels;

@end
