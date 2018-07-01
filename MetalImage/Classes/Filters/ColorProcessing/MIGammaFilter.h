//
//  MIGammaFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

@interface MIGammaFilter : MIFilter
{
    id<MTLBuffer> _gammaBuffer;
}

// Gamma ranges from 0.0 to 3.0, with 1.0 as the normal level
@property (nonatomic) float gamma;


@end
