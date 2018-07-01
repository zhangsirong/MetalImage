//
//  MISwirlFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MISwirlFragmentShader(MIDefaultVertexData in [[stage_in]],
                                      texture2d<half> colorTexture [[ texture(0) ]],
                                      constant float2 *centers [[ buffer(0) ]],
                                      constant float *radiuss [[ buffer(1) ]],
                                      constant float *angles [[ buffer(2) ]])
{
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    
    
    float2 center = centers[0];
    float radius = radiuss[0];
    float angle = angles[0];
    float2 textureCoordinate = in.textureCoordinate;
    
    float2 textureCoordinateToUse = textureCoordinate;
    float dist = distance(center, textureCoordinate);
    if (dist < radius) {
        textureCoordinateToUse -= center;
        float percent = (radius - dist) / radius;
        float theta = percent * percent * angle * 8.0;
        float s = sin(theta);
        float c = cos(theta);
        textureCoordinateToUse = float2(dot(textureCoordinateToUse, float2(c, -s)), dot(textureCoordinateToUse, float2(s, c)));
        textureCoordinateToUse += center;
    }
    
    half4 textureColor = colorTexture.sample (sourceImage, textureCoordinateToUse);
    
    return textureColor;
    
}
