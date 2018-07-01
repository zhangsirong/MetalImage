//
//  MIThresholdEdgeDetectionFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MISobelEdgeDetectionFilter.h"

@interface MIThresholdEdgeDetectionFilter : MISobelEdgeDetectionFilter
{
    id<MTLBuffer> _thresholdBuffer;
}

@property (nonatomic) float threshold;

@end
