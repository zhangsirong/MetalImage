//
//  MI3x3ConvolutionFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MI3x3ConvolutionFragmentShader(MINearbyTexelVertexData in [[stage_in]],
                                               texture2d<half> inputTexture [[texture(0)]],
                                               constant float3x3 *convolutionMatrixs [[buffer(0)]]) {
    half3x3 convolutionMatrix = (half3x3)convolutionMatrixs[0];
    
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    
    half3 bottomColor = inputTexture.sample(sourceImage, in.bottomTextureCoordinate).rgb;
    half3 bottomLeftColor = inputTexture.sample(sourceImage, in.bottomLeftTextureCoordinate).rgb;
    half3 bottomRightColor = inputTexture.sample(sourceImage, in.bottomRightTextureCoordinate).rgb;
    half4 centerColor = inputTexture.sample(sourceImage, in.textureCoordinate);
    half3 leftColor = inputTexture.sample(sourceImage, in.leftTextureCoordinate).rgb;
    half3 rightColor = inputTexture.sample(sourceImage, in.rightTextureCoordinate).rgb;
    half3 topColor = inputTexture.sample(sourceImage, in.topTextureCoordinate).rgb;
    half3 topRightColor = inputTexture.sample(sourceImage, in.topRightTextureCoordinate).rgb;
    half3 topLeftColor = inputTexture.sample(sourceImage, in.topLeftTextureCoordinate).rgb;
    
    half3 resultColor = topLeftColor * convolutionMatrix[0][0] + topColor * convolutionMatrix[0][1] + topRightColor * convolutionMatrix[0][2];
    resultColor += leftColor * convolutionMatrix[1][0] + centerColor.rgb * convolutionMatrix[1][1] + rightColor * convolutionMatrix[1][2];
    resultColor += bottomLeftColor * convolutionMatrix[2][0] + bottomColor * convolutionMatrix[2][1] + bottomRightColor * convolutionMatrix[2][2];
    
    half4 outputColor = half4(resultColor, centerColor.a);
    return outputColor;
}
