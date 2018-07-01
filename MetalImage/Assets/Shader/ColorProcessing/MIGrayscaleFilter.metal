//
//  MIGrayscaleFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MILuminanceFragmentShader(MIDefaultVertexData in [[stage_in]],
                                         texture2d<half> inputTexture [[ texture(0) ]]) {
    constexpr sampler textureSample (mag_filter::linear, min_filter::linear);
    
    half4 textureColor = inputTexture.sample (textureSample, in.textureCoordinate);
    half luminance = dot(textureColor.rgb, luminanceWeighting);
    
    textureColor = half4(half3(luminance), textureColor.a);
    
    return textureColor;
}
