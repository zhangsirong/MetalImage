//
//  MISphereRefractionFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MISphereRefractionFragmentShader(MIDefaultVertexData in [[stage_in]],
                                               texture2d<half> colorTexture [[ texture(0) ]],
                                               constant float *aspectRatios [[ buffer(0) ]],
                                               constant float2 *centers [[ buffer(1) ]],
                                               constant float *radiuss [[ buffer(2) ]],
                                               constant float *refractiveIndexs [[ buffer(3) ]] )
{
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    
    
    float aspectRatio = aspectRatios[0];
    float2 center = centers[0];
    float radius = radiuss[0];
    float refractiveIndex = refractiveIndexs[0];
    float2 textureCoordinate = in.textureCoordinate;
    
    float2 textureCoordinateToUse = float2(textureCoordinate.x, (textureCoordinate.y * aspectRatio + 0.5 - 0.5 * aspectRatio));
    float distanceFromCenter = distance(center, textureCoordinateToUse);
    float checkForPresenceWithinSphere = step(distanceFromCenter, radius);
    
    distanceFromCenter = distanceFromCenter / radius;
    
    float normalizedDepth = radius * sqrt(1.0 - distanceFromCenter * distanceFromCenter);
    float3 sphereNormal = normalize(float3(textureCoordinateToUse - center, normalizedDepth));
    
    float3 refractedVector = refract(float3(0.0, 0.0, -1.0), sphereNormal, refractiveIndex);
    
//    half4 textureColor = colorTexture.sample (sourceImage, (refractedVector.xy + 1.0) * 0.5) * checkForPresenceWithinSphere;
    
    half4 textureColor = colorTexture.sample (sourceImage, 1.0 - (refractedVector.xy + 1.0) * 0.5) * checkForPresenceWithinSphere;
    
    return textureColor;
}

