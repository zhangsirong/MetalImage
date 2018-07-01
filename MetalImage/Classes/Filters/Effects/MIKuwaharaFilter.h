//
//  MIKuwaharaFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

@interface MIKuwaharaFilter : MIFilter
{
    id<MTLBuffer> _radiusBuffer;
}

/// The radius to sample from when creating the brush-stroke effect, with a default of 3. The larger the radius, the slower the filter.

@property (nonatomic) int radius;

@end
