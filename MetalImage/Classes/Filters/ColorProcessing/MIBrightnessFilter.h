//
//  MIBrightnessFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

@interface MIBrightnessFilter : MIFilter
{
    id<MTLBuffer> _brightnessBuffer;
}

// Brightness ranges from -1.0 to 1.0, with 0.0 as the normal level
@property (nonatomic) float brightness;

@end

