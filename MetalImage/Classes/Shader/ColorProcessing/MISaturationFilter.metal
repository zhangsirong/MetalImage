//
//  MISaturationFilter.metal
//  StyleCamera
//
//  Created by admin on 7/6/18.
//  Copyright © 2018年 Lpzsrong Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MISaturationFragmentShader(MIDefaultVertexData in [[stage_in]],
                                           texture2d<half> colorTexture [[ texture(0) ]],
                                           constant float *saturations [[buffer(0)]])
{
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    
    half saturation = saturations[0];
    
    half4 textureColor = colorTexture.sample (sourceImage, in.textureCoordinate);
    
    float luminance = dot(textureColor.rgb, luminanceWeighting);
    half3 greyScaleColor = half3(luminance);
    
    
    textureColor = half4(mix(greyScaleColor, textureColor.rgb, saturation), textureColor.w);
    return textureColor;
}

