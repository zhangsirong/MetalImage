//
//  MIExposureFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

@interface MIExposureFilter : MIFilter
{
    id<MTLBuffer> _exposureBuffer;
}

// Exposure ranges from -10.0 to 10.0, with 0.0 as the normal level
@property (nonatomic) float exposure;

@end
