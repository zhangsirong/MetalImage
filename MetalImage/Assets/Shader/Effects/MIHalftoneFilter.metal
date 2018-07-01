//
//  MIHalftoneFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MIHalftoneFragmentShader(MIDefaultVertexData in [[stage_in]],
                                        texture2d<half> inputTexture [[ texture(0) ]],
                                        constant float *fractionalWidthOfPixels [[buffer(1)]],
                                        constant float *aspectRatios [[buffer(2)]] ) {
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    
    float fractionalWidthOfPixel = fractionalWidthOfPixels[0];
    float aspectRatio = aspectRatios[0];
    
    float2 sampleDivisor = float2(fractionalWidthOfPixel, fractionalWidthOfPixel / aspectRatio);
    
    float2 samplePos = in.textureCoordinate - fmod(in.textureCoordinate, sampleDivisor) + 0.5 * sampleDivisor;
    float2 adjustedSamplePos = float2(samplePos.x, (samplePos.y * aspectRatio + 0.5 - 0.5 * aspectRatio));
    
    float2 textureCoordinateToUse = float2(in.textureCoordinate.x, (in.textureCoordinate.y * aspectRatio + 0.5 - 0.5 * aspectRatio));
    
    float distanceFromSamplePoint = distance(adjustedSamplePos, textureCoordinateToUse);
    
    half4 outputColor = inputTexture.sample (sourceImage, samplePos);
    
    half3 sampledColor =  outputColor.xyz;
    
    float dotScaling = 1.0 - dot(sampledColor, luminanceWeighting);
    
    float checkForPresenceWithinDot = 1.0 - step(distanceFromSamplePoint, (fractionalWidthOfPixel * 0.5) * dotScaling);
    
    outputColor = half4(half3(checkForPresenceWithinDot), 1.0);
    
    return outputColor;
}

