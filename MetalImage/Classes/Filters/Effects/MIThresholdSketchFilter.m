//
//  MIThresholdSketchFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIThresholdSketchFilter.h"

@implementation MIThresholdSketchFilter

+ (NSString *)secondFragmentShaderFunction {
    NSString *fFunction = @"MIThresholdSketchFragmentShader";
    return fFunction;
}

@end
