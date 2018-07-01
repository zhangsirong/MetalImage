//
//  MIPolarPixellateFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MIPolarPixellateFragmentShader(MIDefaultVertexData in [[stage_in]],
                                              texture2d<half> inputTexture [[ texture(0) ]],
                                              constant float2 *centers [[buffer(1)]],
                                              constant float2 *pixelSizes [[buffer(2)]])
{
    constexpr sampler inputSampler (mag_filter::linear, min_filter::linear);
    
    float2 textureCoordinate = in.textureCoordinate;
    float2 center = centers[0];
    float2 pixelSize = pixelSizes[0];
    
    float2 normCoord = 2.0 * textureCoordinate - 1.0;
    float2 normCenter = 2.0 * center - 1.0;
    
    normCoord -= normCenter;
    
    float r = length(normCoord); // to polar coords
    float phi = atan2(normCoord.y, normCoord.x); // to polar coords
    
    r = r - fmod(r, pixelSize.x) + 0.03;
    phi = phi - fmod(phi, pixelSize.y);
    
    normCoord.x = r * cos(phi);
    normCoord.y = r * sin(phi);
    
    normCoord += normCenter;
    
    float2 textureCoordinateToUse = normCoord / 2.0 + 0.5;
    
    half4 outputColor = inputTexture.sample (inputSampler, textureCoordinateToUse);
    
    return outputColor;
}
