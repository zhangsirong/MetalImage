//
//  MIMonochromeFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MIMonochromeFragmentShader(MIDefaultVertexData in [[stage_in]],
                                           texture2d<half> colorTexture [[ texture(0) ]],
                                           constant float *intensitys [[buffer(0)]],
                                           constant float3 *filterColors [[buffer(1)]])
{
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    float3 filterColor = filterColors[0];
    half intensity = intensitys[0];
    
    //desat, then apply overlay blend
    half4 textureColor = colorTexture.sample (sourceImage, in.textureCoordinate);
    half luminance = dot(textureColor.rgb, luminanceWeighting);
    
    float4 desat = float4(float3(luminance), 1.0);
    
    //overlay
    half4 outputColor = half4(
                            (desat.r < 0.5 ? (2.0 * desat.r * filterColor.r) : (1.0 - 2.0 * (1.0 - desat.r) * (1.0 - filterColor.r))),
                            (desat.g < 0.5 ? (2.0 * desat.g * filterColor.g) : (1.0 - 2.0 * (1.0 - desat.g) * (1.0 - filterColor.g))),
                            (desat.b < 0.5 ? (2.0 * desat.b * filterColor.b) : (1.0 - 2.0 * (1.0 - desat.b) * (1.0 - filterColor.b))),
                            1.0
                            );
    
    //which is better, or are they equal?
    outputColor = half4( mix(textureColor.rgb, outputColor.rgb, intensity), textureColor.a);
    return outputColor;
}
