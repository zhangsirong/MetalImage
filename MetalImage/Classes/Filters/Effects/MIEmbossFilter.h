//
//  MIEmbossFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MI3x3ConvolutionFilter.h"

@interface MIEmbossFilter : MI3x3ConvolutionFilter
// The strength of the embossing, from  0.0 to 4.0, with 1.0 as the normal level
@property (nonatomic) float intensity;

@end
