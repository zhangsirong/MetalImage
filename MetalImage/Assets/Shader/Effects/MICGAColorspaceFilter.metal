//
//  MICGAColorspaceFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MICGAColorspaceFragmentShader(MIDefaultVertexData in [[stage_in]],
                                             texture2d<half> colorTexture [[ texture(0) ]]) {
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    
    float2 sampleDivisor = float2(1.0 / 200.0, 1.0 / 320.0);
    float2 samplePos = in.textureCoordinate - fmod(in.textureCoordinate, sampleDivisor);
    half4 color = colorTexture.sample (sourceImage, samplePos );
    
    half4 colorCyan = half4(85.0 / 255.0, 1.0, 1.0, 1.0);
    half4 colorMagenta = half4(1.0, 85.0 / 255.0, 1.0, 1.0);
    half4 colorWhite = half4(1.0, 1.0, 1.0, 1.0);
    half4 colorBlack = half4(0.0, 0.0, 0.0, 1.0);
    
//    half4 endColor;
    half blackDistance = distance(color, colorBlack);
    half whiteDistance = distance(color, colorWhite);
    half magentaDistance = distance(color, colorMagenta);
    half cyanDistance = distance(color, colorCyan);
    
    half4 finalColor;
    
    half colorDistance = min(magentaDistance, cyanDistance);
    colorDistance = min(colorDistance, whiteDistance);
    colorDistance = min(colorDistance, blackDistance);
    
    if (colorDistance == blackDistance) {
        finalColor = colorBlack;
    } else if (colorDistance == whiteDistance) {
        finalColor = colorWhite;
    } else if (colorDistance == cyanDistance) {
        finalColor = colorCyan;
    } else {
        finalColor = colorMagenta;
    }
    
    return finalColor;
}

