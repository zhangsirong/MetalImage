//
//  MIBlendFilter.h
//  MetalImage
//
//  Created by zsr on 2018/07/10.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MITwoInputFilter.h"

typedef NS_ENUM(NSUInteger, MIBlendMode) {
    MIBlendModeNormal,
    MIBlendModeMultiply,
    MIBlendModeScreen,
    MIBlendModeHardLight,
    MIBlendModeLighten,
    MIBlendModeLinearLight,
    MIBlendModeColorDodge,
    MIBlendModeSoftLight,
    MIBlendModeVividLight,
    MIBlendModeLinearBurn,
    MIBlendModeColorBurn,
    MIBlendModeDarken,
    MIBlendModeDifference,
    MIBlendModeExclusion,
};

@interface MIBlendFilter : MITwoInputFilter
{
    id<MTLBuffer> _blendModeBuffer;
    id<MTLBuffer> _intensityBuffer;
}

@property (nonatomic, readwrite) float intensity;
@property (nonatomic, readwrite) MIBlendMode blendMode;

@end
