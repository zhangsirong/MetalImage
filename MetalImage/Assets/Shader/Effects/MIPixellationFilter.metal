//
//  MIPixellationFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MIPixellationFragmentShader(MIDefaultVertexData in [[stage_in]],
                                           texture2d<half> inputTexture [[ texture(0) ]],
                                           constant float *fractionalWidthOfPixels [[buffer(1)]],
                                           constant float *aspectRatios [[buffer(2)]]) {
    constexpr sampler inputSampler (mag_filter::linear, min_filter::linear);
    
    float fractionalWidthOfPixel = fractionalWidthOfPixels[0];
    float aspectRatio = aspectRatios[0];
    
    float2 sampleDivisor = float2(fractionalWidthOfPixel, fractionalWidthOfPixel / aspectRatio);
    
    float2 samplePos = in.textureCoordinate - fmod(in.textureCoordinate, sampleDivisor) + 0.5 * sampleDivisor;
    
    half4 outputColor = inputTexture.sample (inputSampler, samplePos);
    
    return outputColor;
}

