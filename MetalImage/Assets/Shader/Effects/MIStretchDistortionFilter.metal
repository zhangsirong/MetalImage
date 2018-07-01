//
//  MIStretchDistortionFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MIStretchDistortionFragmentShader(MIDefaultVertexData in [[stage_in]],
                                               texture2d<half> colorTexture [[ texture(0) ]],
                                               constant float2 *centers [[buffer(0)]])
{
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    
    float2 center = centers[0];
    float2 textureCoordinate = in.textureCoordinate;
    
    float2 normCoord = 2.0 * textureCoordinate - 1.0;
    float2 normCenter = 2.0 * center - 1.0;
    
    normCoord -= normCenter;
    float2 s = sign(normCoord);
    normCoord = abs(normCoord);
    normCoord = 0.5 * normCoord + 0.5 * smoothstep(0.25, 0.5, normCoord) * normCoord;
    normCoord = s * normCoord;
    
    normCoord += normCenter;
    
    float2 textureCoordinateToUse = normCoord / 2.0 + 0.5;
    
    half4 colorSample = colorTexture.sample (sourceImage, textureCoordinateToUse);
    return colorSample;
}


