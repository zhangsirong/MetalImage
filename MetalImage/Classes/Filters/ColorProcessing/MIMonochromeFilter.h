//
//  MIMonochromeFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

@interface MIMonochromeFilter : MIFilter
{
    id<MTLBuffer> _intensityBuffer;
    id<MTLBuffer> _filterColorBuffer;
}

@property (nonatomic) float intensity;
@property (nonatomic) vector_float4 color;

- (void)setColorRed:(float)redComponent green:(float)greenComponent blue:(float)blueComponent;

@end

