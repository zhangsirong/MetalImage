//
//  MIKuwaharaRadius3Filter.metal
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#include "MIMetalHeader.h"

constant float2 src_size = float2 (1.0 / 750, 1.0 / 1000);

fragment half4 MIKuwaharaRadius3FragmentShader(MIDefaultVertexData in [[stage_in]],
                                               texture2d<half> colorTexture [[ texture(0) ]])
{
    constexpr sampler sourceImage (mag_filter::linear, min_filter::linear);
    float2 uv = in.textureCoordinate;
    half n = half(16); // radius is assumed to be 3
    half3 m0 = half3(0.0); half3 m1 = half3(0.0); half3 m2 = half3(0.0); half3 m3 = half3(0.0);
    half3 s0 = half3(0.0); half3 s1 = half3(0.0); half3 s2 = half3(0.0); half3 s3 = half3(0.0);
    half3 c;
    half3 cSq;
    
    c = colorTexture.sample (sourceImage, uv + float2(-3,-3) * src_size).rgb;
    m0 += c;
    s0 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(-3,-2) * src_size).rgb;
    m0 += c;
    s0 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(-3,-1) * src_size).rgb;
    m0 += c;
    s0 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(-3,0) * src_size).rgb;
    cSq = c * c;
    m0 += c;
    s0 += cSq;
    m1 += c;
    s1 += cSq;
    
    c = colorTexture.sample (sourceImage, uv + float2(-2,-3) * src_size).rgb;
    m0 += c;
    s0 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(-2,-2) * src_size).rgb;
    m0 += c;
    s0 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(-2,-1) * src_size).rgb;
    m0 += c;
    s0 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(-2,0) * src_size).rgb;
    cSq = c * c;
    m0 += c;
    s0 += cSq;
    m1 += c;
    s1 += cSq;
    
    c = colorTexture.sample (sourceImage, uv + float2(-1,-3) * src_size).rgb;
    m0 += c;
    s0 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(-1,-2) * src_size).rgb;
    m0 += c;
    s0 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(-1,-1) * src_size).rgb;
    m0 += c;
    s0 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(-1,0) * src_size).rgb;
    cSq = c * c;
    m0 += c;
    s0 += cSq;
    m1 += c;
    s1 += cSq;
    
    c = colorTexture.sample (sourceImage, uv + float2(0,-3) * src_size).rgb;
    cSq = c * c;
    m0 += c;
    s0 += cSq;
    m3 += c;
    s3 += cSq;
    c = colorTexture.sample (sourceImage, uv + float2(0,-2) * src_size).rgb;
    cSq = c * c;
    m0 += c;
    s0 += cSq;
    m3 += c;
    s3 += cSq;
    c = colorTexture.sample (sourceImage, uv + float2(0,-1) * src_size).rgb;
    cSq = c * c;
    m0 += c;
    s0 += cSq;
    m3 += c;
    s3 += cSq;
    c = colorTexture.sample (sourceImage, uv + float2(0,0) * src_size).rgb;
    cSq = c * c;
    m0 += c;
    s0 += cSq;
    m1 += c;
    s1 += cSq;
    m2 += c;
    s2 += cSq;
    m3 += c;
    s3 += cSq;
    
    c = colorTexture.sample (sourceImage, uv + float2(-3,3) * src_size).rgb;
    m1 += c;
    s1 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(-3,2) * src_size).rgb;
    m1 += c;
    s1 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(-3,1) * src_size).rgb;
    m1 += c;
    s1 += c * c;
    
    c = colorTexture.sample (sourceImage, uv + float2(-2,3) * src_size).rgb;
    m1 += c;
    s1 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(-2,2) * src_size).rgb;
    m1 += c;
    s1 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(-2,1) * src_size).rgb;
    m1 += c;
    s1 += c * c;
    
    c = colorTexture.sample (sourceImage, uv + float2(-1,3) * src_size).rgb;
    m1 += c;
    s1 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(-1,2) * src_size).rgb;
    m1 += c;
    s1 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(-1,1) * src_size).rgb;
    m1 += c;
    s1 += c * c;
    
    c = colorTexture.sample (sourceImage, uv + float2(0,3) * src_size).rgb;
    cSq = c * c;
    m1 += c;
    s1 += cSq;
    m2 += c;
    s2 += cSq;
    c = colorTexture.sample (sourceImage, uv + float2(0,2) * src_size).rgb;
    cSq = c * c;
    m1 += c;
    s1 += cSq;
    m2 += c;
    s2 += cSq;
    c = colorTexture.sample (sourceImage, uv + float2(0,1) * src_size).rgb;
    cSq = c * c;
    m1 += c;
    s1 += cSq;
    m2 += c;
    s2 += cSq;
    
    c = colorTexture.sample (sourceImage, uv + float2(3,3) * src_size).rgb;
    m2 += c;
    s2 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(3,2) * src_size).rgb;
    m2 += c;
    s2 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(3,1) * src_size).rgb;
    m2 += c;
    s2 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(3,0) * src_size).rgb;
    cSq = c * c;
    m2 += c;
    s2 += cSq;
    m3 += c;
    s3 += cSq;
    
    c = colorTexture.sample (sourceImage, uv + float2(2,3) * src_size).rgb;
    m2 += c;
    s2 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(2,2) * src_size).rgb;
    m2 += c;
    s2 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(2,1) * src_size).rgb;
    m2 += c;
    s2 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(2,0) * src_size).rgb;
    cSq = c * c;
    m2 += c;
    s2 += cSq;
    m3 += c;
    s3 += cSq;
    
    c = colorTexture.sample (sourceImage, uv + float2(1,3) * src_size).rgb;
    m2 += c;
    s2 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(1,2) * src_size).rgb;
    m2 += c;
    s2 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(1,1) * src_size).rgb;
    m2 += c;
    s2 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(1,0) * src_size).rgb;
    cSq = c * c;
    m2 += c;
    s2 += cSq;
    m3 += c;
    s3 += cSq;
    
    c = colorTexture.sample (sourceImage, uv + float2(3,-3) * src_size).rgb;
    m3 += c;
    s3 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(3,-2) * src_size).rgb;
    m3 += c;
    s3 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(3,-1) * src_size).rgb;
    m3 += c;
    s3 += c * c;
    
    c = colorTexture.sample (sourceImage, uv + float2(2,-3) * src_size).rgb;
    m3 += c;
    s3 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(2,-2) * src_size).rgb;
    m3 += c;
    s3 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(2,-1) * src_size).rgb;
    m3 += c;
    s3 += c * c;
    
    c = colorTexture.sample (sourceImage, uv + float2(1,-3) * src_size).rgb;
    m3 += c;
    s3 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(1,-2) * src_size).rgb;
    m3 += c;
    s3 += c * c;
    c = colorTexture.sample (sourceImage, uv + float2(1,-1) * src_size).rgb;
    m3 += c;
    s3 += c * c;
    
    half min_sigma2 = 1e+2;
    m0 /= n;
    s0 = abs(s0 / n - m0 * m0);
    
    half4 colorSample = half4(1.0);
    
    half sigma2 = s0.r + s0.g + s0.b;
    if (sigma2 < min_sigma2) {
        min_sigma2 = sigma2;
        colorSample = half4(m0, 1.0);
    }
    
    m1 /= n;
    s1 = abs(s1 / n - m1 * m1);
    
    sigma2 = s1.r + s1.g + s1.b;
    if (sigma2 < min_sigma2) {
        min_sigma2 = sigma2;
        colorSample = half4(m1, 1.0);
    }
    
    m2 /= n;
    s2 = abs(s2 / n - m2 * m2);
    
    sigma2 = s2.r + s2.g + s2.b;
    if (sigma2 < min_sigma2) {
        min_sigma2 = sigma2;
        colorSample = half4(m2, 1.0);
    }
    
    m3 /= n;
    s3 = abs(s3 / n - m3 * m3);
    
    sigma2 = s3.r + s3.g + s3.b;
    if (sigma2 < min_sigma2) {
        min_sigma2 = sigma2;
        colorSample = half4(m3, 1.0);
    }
    
    return colorSample;
}

