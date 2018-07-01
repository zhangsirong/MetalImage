//
//  MIPixellatePositionFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MIPixellatePositionFragmentShader(MIDefaultVertexData in [[stage_in]],
                                                 texture2d<half> inputTexture [[ texture(0) ]],
                                                 constant float *fractionalWidthOfPixels [[buffer(1)]],
                                                 constant float *aspectRatios [[buffer(2)]],
                                                 constant float2 *pixelPosition [[buffer(3)]],
                                                 constant float *pixelRadius [[buffer(4)]])
{
    constexpr sampler inputSampler (mag_filter::linear, min_filter::linear);
    
    float fractionalWidthOfPixel = fractionalWidthOfPixels[0];
    float aspectRatio = aspectRatios[0];
    
    float2 center = pixelPosition[0];
    float radius = pixelRadius[0];
    
    float2 textureCoordinateToUse = float2(in.textureCoordinate.x, (in.textureCoordinate.y * aspectRatio + 0.5 - 0.5 * aspectRatio));
    float dist = distance(center, textureCoordinateToUse);
    half4 outputColor;
    
    if (dist < radius) {
        float2 sampleDivisor = float2(fractionalWidthOfPixel, fractionalWidthOfPixel / aspectRatio);
        float2 samplePos = in.textureCoordinate - fmod(in.textureCoordinate, sampleDivisor) + 0.5 * sampleDivisor;
        outputColor = inputTexture.sample (inputSampler, samplePos);
    } else {
        outputColor = inputTexture.sample (inputSampler, in.textureCoordinate);
    }
    
    return outputColor;
}
