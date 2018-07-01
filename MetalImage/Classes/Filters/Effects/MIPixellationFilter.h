//
//  MIPixellationFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

/**
 像素化
 */
@interface MIPixellationFilter : MIFilter
/**
 0～1，宽度有个像素化，如1.0/20就是20个像素   默认1.0/20
 */

@property (nonatomic) float fractionalWidthOfAPixel;

@end
