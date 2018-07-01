//
//  MIGrayscaleFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIGrayscaleFilter.h"

@implementation MIGrayscaleFilter

+ (NSString *)fragmentShaderFunction {
    NSString *fFunction = @"MILuminanceFragmentShader";
    return fFunction;
}

@end
