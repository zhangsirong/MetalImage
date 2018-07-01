//
//  MIPolkaDotFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIPixellationFilter.h"

/**
 小原点像素化
 */
@interface MIPolkaDotFilter : MIPixellationFilter

@property(nonatomic, assign) float dotScaling;//默认0.9

@end

