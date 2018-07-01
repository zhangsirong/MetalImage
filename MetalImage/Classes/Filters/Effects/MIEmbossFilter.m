//
//  MIEmbossFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIEmbossFilter.h"

@implementation MIEmbossFilter

- (instancetype)init {
    if (self = [super init]) {
        self.intensity = 1.0;
    }
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setIntensity:(float)intensity {
//    self.convolutionKernel = simd_matrix(vector3(-2.0f, -1.0f, 0.0f),
//                                         vector3(-1.0f,  1.0f, 1.0f),
//                                         vector3( 0.0f,  1.0f, 2.0f));
    
    _intensity = intensity;
    
    matrix_float3x3 newConvolutionMatrix = simd_matrix(vector3(_intensity * (-2.0f), -_intensity, 0.0f),
                                                       vector3(-_intensity,  1.0f, _intensity),
                                                       vector3( 0.0f,  _intensity, _intensity * 2.0f));
    self.convolutionKernel = newConvolutionMatrix;
}

@end
