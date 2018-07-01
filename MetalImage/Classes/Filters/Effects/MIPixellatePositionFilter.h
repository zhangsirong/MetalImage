//
//  MIPixellatePositionFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIPixellationFilter.h"

/**
 同心圆像素化
 */
@interface MIPixellatePositionFilter : MIPixellationFilter

// the center point to start pixelation in texture coordinates, default 0.5, 0.5
@property(nonatomic, assign) CGPoint center;

// the radius (0.0 - 1.0) in which to pixelate, default 0.5
@property(nonatomic, assign) float radius;

@end
