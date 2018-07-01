//
//  MIColorInvertFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIColorInvertFilter.h"

@implementation MIColorInvertFilter

+ (NSString *)fragmentShaderFunction {
    NSString *funciton = @"MIColorInvertFragmentShader";
    return funciton;
}

@end
