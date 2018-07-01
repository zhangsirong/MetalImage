//
//  MIGlassSphereFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

constant float3 lightPosition = float3(-0.5, 0.5, 1.0);
constant float3 ambientLightPosition = float3(0.0, 0.0, 1.0);

fragment half4 MIGlassSphereFragmentShader(MIDefaultVertexData in [[stage_in]],
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
    
    float3 refractedVector = 2.0 * refract(float3(0.0, 0.0, -1.0), sphereNormal, refractiveIndex);
    refractedVector.xy = -refractedVector.xy;
    
    half3 finalSphereColor = colorTexture.sample (sourceImage, (refractedVector.xy + 1.0) * 0.5).rgb;
    
    // Grazing angle lighting
    float lightingIntensity = 2.5 * (1.0 - pow(clamp(dot(ambientLightPosition, sphereNormal), 0.0, 1.0), 0.25));
    finalSphereColor += lightingIntensity;
    
    // Specular lighting
    lightingIntensity  = clamp(dot(normalize(lightPosition), sphereNormal), 0.0, 1.0);
    lightingIntensity  = pow(lightingIntensity, 15.0);
    finalSphereColor += half3(0.8) * lightingIntensity;
    
    half4 textureColor = half4(finalSphereColor, 1.0) * checkForPresenceWithinSphere;
    
    return textureColor;
}


