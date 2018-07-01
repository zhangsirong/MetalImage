//
//  MIColorInvertFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment float4 MIColorInvertFragmentShader(MIDefaultVertexData in [[stage_in]],
                                           texture2d<float> colorTexture [[ texture(0) ]],
                                           constant float *intensitys [[buffer(0)]],
                                           constant float3 *filterColors [[buffer(1)]])
{
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    float4 textureColor = colorTexture.sample (sourceImage, in.textureCoordinate);
    float4 outputColor = float4((1.0 - textureColor.rgb), textureColor.w);
    return outputColor;

}
