//
//  MIMetalHeader.h
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#ifndef MIMetalHeader_h
#define MIMetalHeader_h
#if !TARGET_IPHONE_SIMULATOR

#include <metal_stdlib>
using namespace metal;
constant half3 luminanceWeighting = half3(0.2125, 0.7154, 0.0721);

struct MIDefaultVertexData {
    float4 position [[position]];
    float2 textureCoordinate;
};

struct MITwoInputVertexData {
    float4 position [[position]];
    float2 textureCoordinate;
    float2 secondTextureCoordinate;
};

struct MINearbyTexelVertexData {
    float4 position [[position]];
    float2 textureCoordinate;
    
    float2 leftTextureCoordinate;
    float2 rightTextureCoordinate;
    
    float2 topTextureCoordinate;
    float2 topLeftTextureCoordinate;
    float2 topRightTextureCoordinate;
    
    float2 bottomTextureCoordinate;
    float2 bottomLeftTextureCoordinate;
    float2 bottomRightTextureCoordinate;
};
#endif

#endif /* MIMetalHeader_h */
