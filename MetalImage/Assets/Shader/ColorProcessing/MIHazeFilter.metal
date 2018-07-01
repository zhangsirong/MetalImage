//
//  MIHazeFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment float4 MIHazeFragmentShader(MIDefaultVertexData in [[stage_in]],
                                     texture2d<float> colorTexture [[ texture(0) ]],
                                     constant float *hazeDistances [[buffer(0)]],
                                     constant float *slopes [[buffer(1)]])
{
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    
    float hazeDistance = hazeDistances[0];
    float slope = slopes[0];
    
    float4 whiteColor = float4(1.0);
    float d = in.textureCoordinate.y * slope + hazeDistance;
    float4 outputColor = colorTexture.sample (sourceImage, in.textureCoordinate);
    outputColor = (outputColor - d * whiteColor) / (1.0 - d);
    
    return outputColor;
    
}
