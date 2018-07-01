//
//  MISolarizeFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MISolarizeFragmentShader(MIDefaultVertexData in [[stage_in]],
                                         texture2d<half> colorTexture [[ texture(0) ]],
                                         constant float *thresholds [[buffer(0)]])
{
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    half threshold = (half)thresholds[0];
    
    half4 textureColor = colorTexture.sample (sourceImage, in.textureCoordinate);
   
    half luminance = dot(textureColor.rgb, luminanceWeighting);
    float thresholdResult = step(luminance, threshold);
    half3 finalColor = abs(thresholdResult - textureColor.rgb);
    
    half4 outputColor = half4(finalColor.rgb, textureColor.a);
    return outputColor;
}
