//
//  MIGlassSphereFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIGlassSphereFilter.h"

@implementation MIGlassSphereFilter

+ (NSString *)fragmentShaderFunction {
    NSString *funciton = @"MIGlassSphereFragmentShader";
    return funciton;
}

@end
