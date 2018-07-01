//
//  MIVignetteFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MIVignetteFragmentShader(MIDefaultVertexData in [[stage_in]],
                                               texture2d<half> colorTexture [[texture(0)]],
                                               constant float2 *vignetteCenters [[buffer(0)]],
                                               constant float3 *vignetteColors [[buffer(1)]],
                                               constant float *vignetteStarts [[buffer(2)]],
                                               constant float *vignetteEnds [[buffer(3)]] )
{
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    float2 textureCoordinate = in.textureCoordinate;
    float2 vignetteCenter = vignetteCenters[0];
    half3 vignetteColor = (half3)vignetteColors[0];
    float vignetteStart = vignetteStarts[0];
    float vignetteEnd = vignetteEnds[0];
    
    half4 sourceImageColor = colorTexture.sample (sourceImage, textureCoordinate);
    float d = distance(textureCoordinate, float2(vignetteCenter.x, vignetteCenter.y));
    half percent = smoothstep(vignetteStart, vignetteEnd, d);
    half4 finalColor = half4(mix(sourceImageColor.rgb, vignetteColor, percent), sourceImageColor.a);
    return finalColor;
}


