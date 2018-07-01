//
//  MICrosshatchFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

fragment half4 MICrosshatchFragmentShader(MIDefaultVertexData in [[stage_in]],
                                          texture2d<half> inputTexture [[ texture(0) ]],
                                          constant float *crossHatchSpacings [[buffer(1)]],
                                          constant float *lineWidths [[buffer(2)]]) {
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    
    float2 textureCoordinate = in.textureCoordinate;
    float crossHatchSpacing = crossHatchSpacings[0];
    float lineWidth = lineWidths[0];
    
    half4 colorToDisplay = inputTexture.sample (sourceImage, textureCoordinate);
    
    half luminance = dot(colorToDisplay.rgb, luminanceWeighting);
    
    colorToDisplay = half4(1.0, 1.0, 1.0, 1.0);
    
    if (luminance < 1.00) {
        if (fmod(textureCoordinate.x + textureCoordinate.y, crossHatchSpacing) <= lineWidth) {
            colorToDisplay = half4(0.0, 0.0, 0.0, 1.0);
        }
    }
    if (luminance < 0.75) {
        if (fabs(textureCoordinate.x - textureCoordinate.y) < lineWidth) {
            if (textureCoordinate.x - textureCoordinate.y < 0) {
                if (fabs(fmod(textureCoordinate.x - textureCoordinate.y, crossHatchSpacing)) <= lineWidth)
                {
                    colorToDisplay = half4(0.0, 0.0, 0.0, 1.0);
                }
                
            }
        }
        else {
            if (fabs(fmod(textureCoordinate.x - textureCoordinate.y, crossHatchSpacing)) <= lineWidth) {
                colorToDisplay = half4(0.0, 0.0, 0.0, 1.0);
            }
        }
        
    }
    if (luminance < 0.50) {
        if (fmod(textureCoordinate.x + textureCoordinate.y - (crossHatchSpacing / 2.0), crossHatchSpacing) <= lineWidth) {
            colorToDisplay = half4(0.0, 0.0, 0.0, 1.0);
        }
    }
    if (luminance < 0.3) {
        if (fabs(textureCoordinate.x - textureCoordinate.y - crossHatchSpacing / 2.0) < lineWidth) {
            if (textureCoordinate.x - textureCoordinate.y - crossHatchSpacing / 2.0 < 0)
            {
                if (fabs(fmod(textureCoordinate.x - textureCoordinate.y - (crossHatchSpacing / 2.0), crossHatchSpacing)) <= lineWidth)
                {
                    colorToDisplay = half4(0.0, 0.0, 0.0, 1.0);
                }
            }
        }
        else {
            if (fabs(fmod(textureCoordinate.x - textureCoordinate.y - (crossHatchSpacing / 2.0), crossHatchSpacing)) <= lineWidth) {
                colorToDisplay = half4(0.0, 0.0, 0.0, 1.0);
            }
        }
    }
    return colorToDisplay;
}
