//
//  MIBrightnessFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment float4 MIBrightnessFragmentShader(MIDefaultVertexData in [[stage_in]],
                                           texture2d<float> colorTexture [[ texture(0) ]],
                                           constant float *brightnesss [[ buffer(0) ]])
{
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    
    float brightness = brightnesss[0];
    
    float4 textureColor = colorTexture.sample (sourceImage, in.textureCoordinate);
    textureColor = float4((textureColor.rgb + float3(brightness)), textureColor.w);
    return textureColor;
}

