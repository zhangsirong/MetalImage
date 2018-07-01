//
//  MIPolarPixellateFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"


/**
 同心圆像素化
 */
@interface MIPolarPixellateFilter : MIFilter

// The center about which to apply the distortion, with a default of (0.5, 0.5)
@property(nonatomic, assign) CGPoint center;
// The amount of distortion to apply, from (-2.0, -2.0) to (2.0, 2.0), with a default of (0.05, 0.05)
@property(nonatomic, assign) CGSize pixelSize;


@end
