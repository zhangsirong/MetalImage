//
//  MIPosterizeFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MIPosterizeFragmentShader(MIDefaultVertexData in [[stage_in]],
                                          texture2d<half> colorTexture [[ texture(0) ]],
                                          constant int *colorLevelss [[ buffer(0) ]])
{
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    
    int colorLevels = colorLevelss[0];
    half4 textureColor = colorTexture.sample (sourceImage, in.textureCoordinate);
    half4 color = floor((textureColor * colorLevels) + half(0.5)) / colorLevels;
    
    return color;
    
}
