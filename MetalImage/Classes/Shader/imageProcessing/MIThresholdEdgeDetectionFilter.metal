//
//  MIThresholdEdgeDetectionFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MIThresholdEdgeDetectionFragmentShader(MINearbyTexelVertexData in [[stage_in]],
                                                      texture2d<half> colorTexture [[texture(0)]],
                                                      constant float *edgeStrengths [[buffer(0)]],
                                                      constant float *thresholds [[buffer(1)]])
{
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    float edgeStrength = edgeStrengths[0];
    float threshold = thresholds[0];
    
//    float bottomLeftIntensity = colorTexture.sample(sourceImage, in.bottomLeftTextureCoordinate).r;
//    float topRightIntensity =  colorTexture.sample(sourceImage, in.topRightTextureCoordinate).r;
//    float topLeftIntensity =  colorTexture.sample(sourceImage, in.topLeftTextureCoordinate).r;
//    float bottomRightIntensity =  colorTexture.sample(sourceImage, in.bottomRightTextureCoordinate).r;
    float leftIntensity = colorTexture.sample(sourceImage, in.leftTextureCoordinate).r;
    float rightIntensity = colorTexture.sample(sourceImage, in.rightTextureCoordinate).r;
    float bottomIntensity = colorTexture.sample(sourceImage, in.bottomTextureCoordinate).r;
    float topIntensity = colorTexture.sample(sourceImage, in.topTextureCoordinate).r;
    
//    float h = -topLeftIntensity - 2.0 * topIntensity - topRightIntensity + bottomLeftIntensity + 2.0 * bottomIntensity + bottomRightIntensity;
//
//    float v = -bottomLeftIntensity - 2.0 * leftIntensity - topLeftIntensity + bottomRightIntensity + 2.0 * rightIntensity + topRightIntensity;

    float centerIntensity = colorTexture.sample(sourceImage, in.textureCoordinate).r;
    float h = (centerIntensity - topIntensity) + (bottomIntensity - centerIntensity);
    float v = (centerIntensity - leftIntensity) + (rightIntensity - centerIntensity);
    
    float mag = length(float2(h, v)) * edgeStrength;
    mag = step(threshold, mag);
    
    half4 colorSample = half4(half3(mag), 1.0);
    return colorSample;
}
