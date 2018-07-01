//
//  MIPerlinNoiseFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

/**
 柏林噪声
 */
@interface MIPerlinNoiseFilter : MIFilter

@property (nonatomic, assign) vector_float4 colorStart;//颜色值RGBA值
@property (nonatomic, assign) vector_float4 colorFinish;//颜色值RGBA值
@property (nonatomic, assign) float scale; //0～10

@end
