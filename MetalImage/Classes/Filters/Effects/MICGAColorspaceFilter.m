//
//  MICGAColorspaceFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MICGAColorspaceFilter.h"

@implementation MICGAColorspaceFilter

+ (NSString *)fragmentShaderFunction {
    NSString *funciton = @"MICGAColorspaceFragmentShader";
    return funciton;
}
@end
