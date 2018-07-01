//
//  MI3x3TextureSamplingFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

vertex MINearbyTexelVertexData MINearbyTexelSamplingVertexShader(uint vertexID [[vertex_id]],
                                                                 constant float4 *position [[buffer(0)]],
                                                                 constant float2 *textureCoordinate [[buffer(1)]],
                                                                 constant float *texelWidths [[buffer(2)]],
                                                                 constant float *texelHeights [[buffer(3)]]) {
    MINearbyTexelVertexData out;
    
    float4 pixelSpacePosition = position[vertexID];
    float2 inputTextureCoordinate = textureCoordinate[vertexID];
    float texelWidth = texelWidths[0];
    float texelHeight = texelHeights[0];
    
    float2 widthStep = float2(texelWidth, 0.0);
    float2 heightStep = float2(0.0, texelHeight);
    float2 widthHeightStep = float2(texelWidth, texelHeight);
    float2 widthNegativeHeightStep = float2(texelWidth, -texelHeight);
    
    out.position = pixelSpacePosition;
    
    out.textureCoordinate = inputTextureCoordinate;
    out.leftTextureCoordinate = inputTextureCoordinate - widthStep;
    out.rightTextureCoordinate = inputTextureCoordinate + widthStep;
    
    out.topTextureCoordinate = inputTextureCoordinate - heightStep;
    out.topLeftTextureCoordinate = inputTextureCoordinate - widthHeightStep;
    out.topRightTextureCoordinate = inputTextureCoordinate + widthNegativeHeightStep;
    
    out.bottomTextureCoordinate = inputTextureCoordinate + heightStep;
    out.bottomLeftTextureCoordinate = inputTextureCoordinate - widthNegativeHeightStep;
    out.bottomRightTextureCoordinate = inputTextureCoordinate + widthHeightStep;
    
    return out;
}

