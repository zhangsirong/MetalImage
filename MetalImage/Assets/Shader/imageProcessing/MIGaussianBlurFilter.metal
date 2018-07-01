//
//  MIGaussianBlurFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//


#include <metal_stdlib>
using namespace metal;

struct VertexData
{
    float4 position [[position]];
    float2 blurCoordinate0;
    float2 blurCoordinate1;
    float2 blurCoordinate2;
    float2 blurCoordinate3;
    float2 blurCoordinate4;
    float2 blurCoordinate5;
    float2 blurCoordinate6;
    float2 blurCoordinate7;
    float2 blurCoordinate8;
    float2 blurCoordinate9;
    float2 blurCoordinate10;
    float2 blurCoordinate11;
    float2 blurCoordinate12;
    float2 blurCoordinate13;
    float2 blurCoordinate14;
};

vertex VertexData MIGaussianBlurVertexShader(uint vertexID [[vertex_id]],
                                             constant float4 *positions [[buffer(0)]],
                                             constant float2 *textureCoordinates [[buffer(1)]],
                                             constant float *texelWidthOffsets [[buffer(2)]],
                                             constant float *texelHeightOffsets [[buffer(3)]],
                                             constant int *blurCounts [[buffer(4)]],
                                             constant float *offsetFromCenters [[buffer(5)]])
{
    VertexData out;
    
    float4 position = positions[vertexID];
    float2 blurCoordinate0 = textureCoordinates[vertexID];
    float texelWidthOffset = texelWidthOffsets[0];
    float texelHeightOffset = texelHeightOffsets[0];
    int blurCount = blurCounts[0];
    
    out.position = position;
    out.blurCoordinate0 = blurCoordinate0;
    
    float2 singleStepOffset = float2(texelWidthOffset, texelHeightOffset);
    
    if (blurCount > 1) {
        out.blurCoordinate1  = blurCoordinate0 + singleStepOffset * offsetFromCenters[1];
        out.blurCoordinate2  = blurCoordinate0 - singleStepOffset * offsetFromCenters[1];
    }
    if (blurCount > 2) {
        out.blurCoordinate3  = blurCoordinate0 + singleStepOffset * offsetFromCenters[2];
        out.blurCoordinate4  = blurCoordinate0 - singleStepOffset * offsetFromCenters[2];
    }
    if (blurCount > 3) {
        out.blurCoordinate5  = blurCoordinate0 + singleStepOffset * offsetFromCenters[3];
        out.blurCoordinate6  = blurCoordinate0 - singleStepOffset * offsetFromCenters[3];
    }
    if (blurCount > 4) {
        out.blurCoordinate7  = blurCoordinate0 + singleStepOffset * offsetFromCenters[4];
        out.blurCoordinate8  = blurCoordinate0 - singleStepOffset * offsetFromCenters[4];
    }
    if (blurCount > 5) {
        out.blurCoordinate9  = blurCoordinate0 + singleStepOffset * offsetFromCenters[5];
        out.blurCoordinate10  = blurCoordinate0 - singleStepOffset * offsetFromCenters[5];
    }
    if (blurCount > 6) {
        out.blurCoordinate11  = blurCoordinate0 - singleStepOffset * offsetFromCenters[6];
        out.blurCoordinate12  = blurCoordinate0 - singleStepOffset * offsetFromCenters[6];
    }
    if (blurCount > 7) {
        out.blurCoordinate13  = blurCoordinate0 - singleStepOffset * offsetFromCenters[7];
        out.blurCoordinate14  = blurCoordinate0 - singleStepOffset * offsetFromCenters[7];
    }
    return out;
}

fragment half4 MIGaussianBlurFragmentShader(VertexData in [[stage_in]],
                                            texture2d<half> colorTexture [[ texture(0) ]],
                                            constant int *blurCounts [[buffer(1)]],
                                            constant float *optimizedWeights [[buffer(2)]])
{
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    
    int blurCount = blurCounts[0];
    half4 sum = half4(0.0);
    
    if (blurCount <= 1) {
        sum = colorTexture.sample (sourceImage, in.blurCoordinate0);
    }
    if (blurCount > 1) {
        sum += colorTexture.sample (sourceImage, in.blurCoordinate1) * optimizedWeights[1];
        sum += colorTexture.sample (sourceImage, in.blurCoordinate2) * optimizedWeights[1];
    }
    if (blurCount > 2) {
        sum += colorTexture.sample (sourceImage, in.blurCoordinate3) * optimizedWeights[2];
        sum += colorTexture.sample (sourceImage, in.blurCoordinate4) * optimizedWeights[2];
    }
    if (blurCount > 3) {
        sum += colorTexture.sample (sourceImage, in.blurCoordinate5) * optimizedWeights[3];
        sum += colorTexture.sample (sourceImage, in.blurCoordinate6) * optimizedWeights[3];
    }
    if (blurCount > 4) {
        sum += colorTexture.sample (sourceImage, in.blurCoordinate7) * optimizedWeights[4];
        sum += colorTexture.sample (sourceImage, in.blurCoordinate8) * optimizedWeights[4];
    }
    if (blurCount > 5) {
        sum += colorTexture.sample (sourceImage, in.blurCoordinate9) * optimizedWeights[5];
        sum += colorTexture.sample (sourceImage, in.blurCoordinate10) * optimizedWeights[5];
    }
    if (blurCount > 6) {
        sum += colorTexture.sample (sourceImage, in.blurCoordinate11) * optimizedWeights[6];
        sum += colorTexture.sample (sourceImage, in.blurCoordinate12) * optimizedWeights[6];
    }
    if (blurCount > 7) {
        sum += colorTexture.sample (sourceImage, in.blurCoordinate13) * optimizedWeights[7];
        sum += colorTexture.sample (sourceImage, in.blurCoordinate14) * optimizedWeights[7];
    }
    
    return sum;
}


