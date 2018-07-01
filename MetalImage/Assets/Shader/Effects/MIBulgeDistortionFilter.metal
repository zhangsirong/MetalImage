//
//  MIBulgeDistortionFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MIBulgeDistortionFragmentShader(MIDefaultVertexData in [[stage_in]],
                                               texture2d<half> colorTexture [[ texture(0) ]],
                                               constant float *aspectRatios [[ buffer(0) ]],
                                               constant float2 *centers [[ buffer(1) ]],
                                               constant float *radiuss [[ buffer(2) ]],
                                               constant float *scales [[ buffer(3) ]] ) {
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    
    
    float aspectRatio = aspectRatios[0];
    float2 center = centers[0];
    float radius = radiuss[0];
    float scale = scales[0];
    float2 textureCoordinate = in.textureCoordinate;
    
    float2 textureCoordinateToUse = float2(textureCoordinate.x, ((textureCoordinate.y - center.y) * aspectRatio) + center.y);
    float dist = distance(center, textureCoordinateToUse);
    textureCoordinateToUse = textureCoordinate;
    
    if (dist < radius)
    {
        textureCoordinateToUse -= center;
        float percent = 1.0 - ((radius - dist) / radius) * scale;
        percent = percent * percent;
        
        textureCoordinateToUse = textureCoordinateToUse * percent;
        textureCoordinateToUse += center;
    }
    
    half4 textureColor = colorTexture.sample (sourceImage, textureCoordinateToUse);
    
    return textureColor;
    
}
