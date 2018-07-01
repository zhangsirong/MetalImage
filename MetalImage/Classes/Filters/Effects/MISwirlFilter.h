//
//  MISwirlFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

@interface MISwirlFilter : MIFilter
{
    id<MTLBuffer> _centerBuffer;
    id<MTLBuffer> _radiusBuffer;
    id<MTLBuffer> _angleBuffer;
}

/// The center about which to apply the distortion, with a default of (0.5, 0.5)
@property (nonatomic) CGPoint center;
/// The radius of the distortion, ranging from 0.0 to 1.0, with a default of 0.5
@property (nonatomic) float radius;
/// The amount of distortion to apply, with a minimum of 0.0 and a default of 1.0
@property (nonatomic) float angle;


@end
