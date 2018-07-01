//
//  MIHalftoneFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIHalftoneFilter.h"

@implementation MIHalftoneFilter

- (instancetype)init {
    if (self = [super init]) {
        self.fractionalWidthOfAPixel = 0.01;
    }
    return self;
}

+ (NSString *)fragmentShaderFunction {
    static NSString *fFunction = @"MIHalftoneFragmentShader";
    return fFunction;
}


@end
