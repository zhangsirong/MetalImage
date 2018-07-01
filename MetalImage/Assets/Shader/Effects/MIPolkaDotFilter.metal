//
//  MIPolkaDotFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MIPolkaDotFragmentShader(MIDefaultVertexData in [[stage_in]],
                                        texture2d<half> colorTexture [[ texture(0) ]],
                                        constant float *fractionalWidthOfPixels [[buffer(1)]],
                                        constant float *aspectRatios [[buffer(2)]],
                                        constant float *dotScalings [[buffer(3)]])
{
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    
    float fractionalWidthOfPixel = fractionalWidthOfPixels[0];
    float aspectRatio = aspectRatios[0];
    float dotScaling = dotScalings[0];
    
    float2 sampleDivisor = float2(fractionalWidthOfPixel, fractionalWidthOfPixel / aspectRatio);
    
    float2 samplePos = in.textureCoordinate - fmod(in.textureCoordinate, sampleDivisor) + 0.5 * sampleDivisor;
    float2 adjustedSamplePos = float2(samplePos.x, (samplePos.y * aspectRatio + 0.5 - 0.5 * aspectRatio));
    
    float2 textureCoordinateToUse = float2(in.textureCoordinate.x, (in.textureCoordinate.y * aspectRatio + 0.5 - 0.5 * aspectRatio));
    
    float distanceFromSamplePoint = distance(adjustedSamplePos, textureCoordinateToUse);
    float checkForPresenceWithinDot = step(distanceFromSamplePoint, (fractionalWidthOfPixel * 0.5) * dotScaling);
    
    half4 colorSample = colorTexture.sample (sourceImage, samplePos);
    
    colorSample = half4(colorSample.rgb * checkForPresenceWithinDot, colorSample.a);
    
    return colorSample;
}


