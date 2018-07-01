//
//  MISketchFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MISketchFragmentShader(MINearbyTexelVertexData in [[stage_in]],
                                       texture2d<half> colorTexture [[texture(0)]],
                                       constant float *edgeStrengths [[buffer(0)]]) {
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    half edgeStrength = edgeStrengths[0];
    
    half bottomLeftIntensity = colorTexture.sample(sourceImage, in.bottomLeftTextureCoordinate).r;
    half topRightIntensity =  colorTexture.sample(sourceImage, in.topRightTextureCoordinate).r;
    half topLeftIntensity =  colorTexture.sample(sourceImage, in.topLeftTextureCoordinate).r;
    half bottomRightIntensity =  colorTexture.sample(sourceImage, in.bottomRightTextureCoordinate).r;
    half leftIntensity = colorTexture.sample(sourceImage, in.leftTextureCoordinate).r;
    half rightIntensity = colorTexture.sample(sourceImage, in.rightTextureCoordinate).r;
    half bottomIntensity = colorTexture.sample(sourceImage, in.bottomTextureCoordinate).r;
    half topIntensity = colorTexture.sample(sourceImage, in.topTextureCoordinate).r;
    half h = -topLeftIntensity - 2.0 * topIntensity - topRightIntensity + bottomLeftIntensity + 2.0 * bottomIntensity + bottomRightIntensity;
    half v = -bottomLeftIntensity - 2.0 * leftIntensity - topLeftIntensity + bottomRightIntensity + 2.0 * rightIntensity + topRightIntensity;
    
    half mag = 1.0 - length(half2(h, v)) * edgeStrength;
    
    half4 colorSample = half4(half3(mag), 1.0);
    return colorSample;
}
