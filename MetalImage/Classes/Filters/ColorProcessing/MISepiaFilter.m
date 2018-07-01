//
//  MISepiaFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MISepiaFilter.h"

@implementation MISepiaFilter
- (instancetype)init {
    if (self = [super init]) {
        self.intensity = 1.0;
        self.colorMatrix = simd_matrix(vector4(0.3588f, 0.7044f, 0.1368f, 0.0f),
                                       vector4(0.2990f, 0.5870f, 0.1140f, 0.0f),
                                       vector4(0.2990f, 0.5870f, 0.1140f, 0.0f),
                                       vector4(0.0f,    0.0f,    0.0f,    1.0f));
    }
    return self;
}
@end
