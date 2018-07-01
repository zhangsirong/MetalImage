//
//  MIColorMatrixFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MIColorMatrixFragmentShader(MIDefaultVertexData in [[stage_in]],
                                            texture2d<half> colorTexture [[ texture(0) ]],
                                            constant float *intensitys [[buffer(0)]],
                                            constant float4x4 *colorMatrixs [[buffer(1)]])
{
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    
    float intensity = intensitys[0];
    half4x4 colorMatrix = (half4x4)colorMatrixs[0];
    
    half4 textureColor = colorTexture.sample (sourceImage, in.textureCoordinate);
    half4 outputColor = textureColor * colorMatrix;

    outputColor = (intensity * outputColor) + ((1.0 - intensity) * textureColor);
    
    return outputColor;
}
