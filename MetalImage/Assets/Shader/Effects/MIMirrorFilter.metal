//
//  MIMirrorFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MIMirrorFragmentShader(MIDefaultVertexData in [[stage_in]],
                                      texture2d<half> inputTexture [[ texture(0) ]],
                                      constant int *orientations [[ buffer(0) ]]) {
    
    constexpr sampler inputSampler (mag_filter::linear, min_filter::linear);
    
    half4 outputColor = inputTexture.sample (inputSampler, in.textureCoordinate);
    
    int orientation = orientations[0];
    
    if (orientation == 0) {
        if (in.textureCoordinate.x > 0.5){
            outputColor = inputTexture.sample (inputSampler, float2(1.0 - in.textureCoordinate.x, in.textureCoordinate.y));
        } else {
            outputColor = inputTexture.sample (inputSampler, in.textureCoordinate);
        }
    } else if (orientation == 1) {
        if (in.textureCoordinate.y > 0.5){
            outputColor = inputTexture.sample (inputSampler, float2(in.textureCoordinate.x, 1.0 - in.textureCoordinate.y));
        } else {
            outputColor = inputTexture.sample (inputSampler, in.textureCoordinate);
        }
    } else {
        outputColor = inputTexture.sample (inputSampler, in.textureCoordinate);
    }
    return outputColor;
}
