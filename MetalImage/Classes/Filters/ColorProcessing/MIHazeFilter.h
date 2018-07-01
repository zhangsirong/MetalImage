//
//  MIHazeFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

@interface MIHazeFilter : MIFilter
{
    id<MTLBuffer> _distanceBuffer;
    id<MTLBuffer> _slopeBuffer;
}

/** Strength of the color applied. Default 0. Values between -.3 and .3 are best
 */
@property (nonatomic) float distance;

/** Amount of color change. Default 0. Values between -.3 and .3 are best
 */
@property (nonatomic) float slope;

@end
