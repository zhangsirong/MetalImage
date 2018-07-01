//
//  MILookupTableFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MILookupTableFragmentShader(MITwoInputVertexData in [[stage_in]],
                                           texture2d<half> inputColor [[ texture(0) ]],
                                           texture2d<half> tableTexture [[ texture(1) ]],
                                           constant float *intensitys [[ buffer(0) ]]) {
    constexpr sampler inputSampler (mag_filter::linear, min_filter::linear);
    constexpr sampler tableImage (mag_filter::linear, min_filter::linear);
    
    half4 outputColor = inputColor.sample (inputSampler, in.textureCoordinate);
    half4 textureColor = outputColor;
    
    half intensity = intensitys[0];
    
    half blueColor = textureColor.b * 15.0;
    
    float2 quad1;
    quad1.y = floor(floor(blueColor) / 4.0);
    quad1.x = floor(blueColor) - (quad1.y * 4.0);
    
    float2 quad2;
    quad2.y = floor(ceil(blueColor) / 4.0);
    quad2.x = ceil(blueColor) - (quad2.y * 4.0);
    
    float2 texPos1;
    texPos1.x = (quad1.x * 0.25) + 0.5/64.0 + ((0.25 - 1.0/64.0) * textureColor.r);
    texPos1.y = (quad1.y * 0.25) + 0.5/64.0 + ((0.25 - 1.0/64.0) * textureColor.g);
    
    float2 texPos2;
    texPos2.x = (quad2.x * 0.25) + 0.5/64.0 + ((0.25 - 1.0/64.0) * textureColor.r);
    texPos2.y = (quad2.y * 0.25) + 0.5/64.0 + ((0.25 - 1.0/64.0) * textureColor.g);
    
    half4 newColor1 = tableTexture.sample (tableImage, texPos1);
    half4 newColor2 = tableTexture.sample (tableImage, texPos2);
    
    half4 newColor = mix(newColor1, newColor2, fract(blueColor));
    half4 result = mix(textureColor, half4(newColor.rgb, textureColor.w), intensity);
    
    return result;
    
}

