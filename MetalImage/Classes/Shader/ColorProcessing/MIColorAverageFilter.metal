//
//  MIColorAverageFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexData {
    float4 position [[position]];
    float2 textureCoordinate;
    float2 upperLeftInputTextureCoordinate;
    float2 upperRightInputTextureCoordinate;
    float2 lowerLeftInputTextureCoordinate;
    float2 lowerRightInputTextureCoordinate;
};

vertex VertexData MIColorAverageVertexShader(uint vertexID [[vertex_id]],
                                             constant float4 *position [[buffer(0)]],
                                             constant float2 *textureCoordinate [[buffer(1)]],
                                             constant float *texelWidths [[buffer(2)]],
                                             constant float *texelHeights [[buffer(3)]])
{
    VertexData out;
    
    float4 pixelSpacePosition = position[vertexID];
    float2 uv = textureCoordinate[vertexID];
    float texelWidth = texelWidths[0];
    float texelHeight = texelHeights[0];
//    texelWidth = 0.25 / 1.0;
//    texelHeight = 0.25 / 1.0;
    
    out.position = pixelSpacePosition;
    out.textureCoordinate = uv;
    out.upperLeftInputTextureCoordinate = uv + float2(-texelWidth, -texelHeight);
    out.upperRightInputTextureCoordinate = uv + float2(texelWidth, -texelHeight);
    out.lowerLeftInputTextureCoordinate = uv + float2(-texelWidth, texelHeight);
    out.lowerRightInputTextureCoordinate = uv + float2(texelWidth, texelHeight);

    return out;
}

fragment float4 MIColorAverageFragmentShader(VertexData in [[stage_in]],
                                         texture2d<float> colorTexture [[ texture(0) ]] )
{
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    
    float4 upperLeftColor = colorTexture.sample (sourceImage, in.upperLeftInputTextureCoordinate);
    float4 upperRightColor = colorTexture.sample (sourceImage, in.upperRightInputTextureCoordinate);
    float4 lowerLeftColor = colorTexture.sample (sourceImage, in.lowerLeftInputTextureCoordinate);
    float4 lowerRightColor = colorTexture.sample (sourceImage, in.lowerRightInputTextureCoordinate);
    
    float4 textureColor = 0.25 * (upperLeftColor + upperRightColor + lowerLeftColor + lowerRightColor);
    
    return textureColor;
}

