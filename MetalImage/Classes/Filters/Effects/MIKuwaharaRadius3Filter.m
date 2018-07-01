//
//  MIKuwaharaRadius3Filter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIKuwaharaRadius3Filter.h"

@implementation MIKuwaharaRadius3Filter

+ (NSString *)fragmentShaderFunction
{
    NSString *function = @"MIKuwaharaRadius3FragmentShader";
    return function;
}

@end
