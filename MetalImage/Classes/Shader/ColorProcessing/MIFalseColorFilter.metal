//
//  MIFalseColorFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MIFalseColorFragmentShader(MIDefaultVertexData in [[stage_in]],
                                           texture2d<half> colorTexture [[ texture(0) ]],
                                           constant float3 *firstColors [[buffer(0)]],
                                           constant float3 *secondColors [[buffer(1)]])
{
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    
    half4 textureColor = colorTexture.sample (sourceImage, in.textureCoordinate);
    
    half3 firstColor = (half3)firstColors[0];
    half3 secondColor = (half3)secondColors[0];
    
    half luminance = dot(textureColor.rgb, luminanceWeighting);
    
    half4 outputColor = half4( mix(firstColor.rgb, secondColor.rgb, luminance), textureColor.a);
    return outputColor;
    
}
