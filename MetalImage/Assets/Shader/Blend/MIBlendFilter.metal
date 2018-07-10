//
//  MIBlendFilter.metal
//  MetalImage
//
//  Created by zsr on 2018/07/10.
//  Copyright © 2018年 zhangsr. All rights reserved.
//

#include "MIMetalHeader.h"

//正常 0
half4 NormalBlend(half4 secondSourceColor, half4 sourceColor, half opacity) {
    if (sourceColor.a > 0.0) {
        half4 result;
        result.rgb = sourceColor.rgb + secondSourceColor.rgb * (1.0 - sourceColor.a);
        result.rgb = clamp(result.rgb, 0.0, 1.0h);
        result.a = max(sourceColor.a, secondSourceColor.a);
        return mix(secondSourceColor, result, opacity);
    }
    
    return secondSourceColor;
}

//正片叠底 1
half4 MultiplyBlend(half4 secondSourceColor, half4 sourceColor, half opacity) {
    if (sourceColor.a > 0.0) {
        sourceColor.rgb = clamp(sourceColor.rgb / sourceColor.a, 0.0, 1.0h);
        half3 result = sourceColor.rgb * secondSourceColor.rgb;
        result = clamp(result, 0.0, 1.0h);
        return half4(mix(secondSourceColor.rgb, result, sourceColor.a * opacity), 1.0h);
    }
    return secondSourceColor;
}

//滤色 2
half4 ScreenBlend(half4 secondSourceColor, half4 sourceColor, half opacity) {
    if (sourceColor.a > 0.0) {
        sourceColor.rgb = clamp(sourceColor.rgb / sourceColor.a, 0.0, 1.0h);
        half3 whiteColor = half3(1.0h);
        half3 result = whiteColor - ((whiteColor - sourceColor.rgb) * (whiteColor - secondSourceColor.rgb));
        result = clamp(result, 0.0, 1.0h);
        return half4(mix(secondSourceColor.rgb, result, sourceColor.a * opacity), 1.0h);
    }
    
    return secondSourceColor;
}

//强光 3
half4 HardLightBlend(half4 secondSourceColor, half4 sourceColor, half opacity) {
    if (sourceColor.a > 0.0) {
        sourceColor.rgb = clamp(sourceColor.rgb / sourceColor.a, 0.0, 1.0h);
        float ra;
        if (sourceColor.r <= 0.5) {
            ra = 2.0 * sourceColor.r * secondSourceColor.r;
        } else {
            ra = 1.0 - 2.0 * (1.0 - sourceColor.r) * (1.0 - secondSourceColor.r);
        }
        
        float ga;
        if (sourceColor.g <= 0.5) {
            ga = 2.0 * sourceColor.g * secondSourceColor.g;
        } else {
            ga = 1.0 - 2.0 * (1.0 - sourceColor.g) * (1.0 - secondSourceColor.g);
        }
        
        float ba;
        if (sourceColor.b <= 0.5) {
            ba = 2.0 * sourceColor.b * secondSourceColor.b;
        } else {
            ba = 1.0 - 2.0 * (1.0 - sourceColor.b) * (1.0 - secondSourceColor.b);
        }
        
        half3 result = half3(ra, ga, ba);
        result = clamp(result, 0.0, 1.0h);
        
        return half4(mix(secondSourceColor.rgb, result, sourceColor.a * opacity), 1.0h);
    }
    
    return secondSourceColor;
}

//变亮 4
half4 LightenBlend(half4 secondSourceColor, half4 sourceColor, half opacity) {
    if (sourceColor.a > 0.0) {
        sourceColor.rgb = clamp(sourceColor.rgb / sourceColor.a, 0.0, 1.0h);
        half3 result = max(sourceColor.rgb, secondSourceColor.rgb);
        result = clamp(result, 0.0, 1.0h);
        return half4(mix(secondSourceColor.rgb, result, sourceColor.a * opacity), 1.0h);
    }
    
    return secondSourceColor;
}

//线性光 5
half4 LinearLightBlend(half4 secondSourceColor, half4 sourceColor, half opacity) {
    if (sourceColor.a > 0.0) {
        sourceColor.rgb = clamp(sourceColor.rgb / sourceColor.a, 0.0, 1.0h);
        half3 result = secondSourceColor.rgb + 2.0 * sourceColor.rgb - half3(1.0h);
        result = clamp(result, 0.0, 1.0h);
        return half4(mix(secondSourceColor.rgb, result, sourceColor.a * opacity), 1.0h);
    }
    
    return secondSourceColor;
}

//颜色减淡 6
half4 ColorDodgeBlend(half4 secondSourceColor, half4 sourceColor, half opacity) {
    if (sourceColor.a > 0.0) {
        sourceColor.rgb = clamp(sourceColor.rgb / sourceColor.a, 0.0, 1.0h);
        half3 white = half3(1.0);
        half3 result = secondSourceColor.rgb / (white - sourceColor.rgb);
        result = clamp(result, 0.0, 1.0h);
        return half4(mix(secondSourceColor.rgb, result, sourceColor.a * opacity), 1.0h);
    }
    
    return secondSourceColor;
}

//柔光 7
half4 SoftLightBlend(half4 secondSourceColor, half4 sourceColor, half opacity) {
    if (sourceColor.a > 0.0) {
        sourceColor.rgb = clamp(sourceColor.rgb / sourceColor.a, 0.0, 1.0h);
        float alphaDivisor = secondSourceColor.a + step(secondSourceColor.a, 0.0h);
        half3 result = secondSourceColor.rgb * (sourceColor.a * (secondSourceColor.rgb / alphaDivisor) + (2.0 * sourceColor.rgb * (1.0 - (secondSourceColor.rgb / alphaDivisor)))) + sourceColor.rgb * (1.0 - secondSourceColor.a) + secondSourceColor.rgb * (1.0 - sourceColor.a);
        result = clamp(result, 0.0, 1.0h);
        
        return half4(mix(secondSourceColor.rgb, result, sourceColor.a * opacity), 1.0h);
    }
    return secondSourceColor;
}

//亮光 8
half4 VividLightBlend(half4 secondSourceColor, half4 sourceColor, half opacity) {
    if (sourceColor.a > 0.0) {
        sourceColor.rgb = clamp(sourceColor.rgb / sourceColor.a, 0.0, 1.0h);
        
        float ra;
        if (sourceColor.r > 0.5) {
            
            ra = secondSourceColor.r / (2.0 * (1.0 - sourceColor.r));
        } else {
            ra = 1.0 - 0.5 * (1.0 - secondSourceColor.r) / sourceColor.r;
        }
        
        float ga;
        if (sourceColor.g > 0.5) {
            
            ga = secondSourceColor.g / (2.0 * (1.0 - sourceColor.g));
        } else {
            ga = 1.0 - 0.5 * (1.0 - secondSourceColor.g) / sourceColor.g;
        }
        float ba;
        if (sourceColor.b > 0.5) {
            
            ba = secondSourceColor.b / (2.0 * (1.0 - sourceColor.b));
        } else {
            ba = 1.0 - 0.5 * (1.0 - secondSourceColor.b) / sourceColor.b;
        }
        
        half3 result = half3(ra, ga, ba);
        result = clamp(result, 0.0, 1.0h);
        return half4(mix(secondSourceColor.rgb, result, sourceColor.a * opacity), 1.0h);
    }
    return secondSourceColor;
}

//线性加深 9
half4 LinearBurnBlend(half4 secondSourceColor, half4 sourceColor, half opacity) {
    if (sourceColor.a > 0.0) {
        sourceColor.rgb = clamp(sourceColor.rgb / sourceColor.a, 0.0, 1.0h);
        half3 result = sourceColor.rgb + secondSourceColor.rgb;
        result = clamp(result, 0.0, 1.0h);
        return half4(mix(secondSourceColor.rgb, result, sourceColor.a * opacity), 1.0h);
    }
    return secondSourceColor;
}

//颜色加深 10
half4 ColorBurnBlend(half4 secondSourceColor, half4 sourceColor, half opacity) {
    if (sourceColor.a > 0.0) {
        half4 whiteColor = half4(1.0);
        sourceColor.rgb = clamp(sourceColor.rgb / sourceColor.a, 0.0, 1.0h);
        half3 result = whiteColor.rgb - (whiteColor.rgb - secondSourceColor.rgb) / sourceColor.rgb;
        result = clamp(result, 0.0, 1.0h);
        return half4(mix(secondSourceColor.rgb, result, sourceColor.a * opacity), 1.0h);
    }
    
    return secondSourceColor;
}

//变暗 11
half4 DarkenBlend(half4 secondSourceColor, half4 sourceColor, half opacity) {
    if (sourceColor.a > 0.0) {
        sourceColor.rgb = clamp(sourceColor.rgb / sourceColor.a, 0.0, 1.0h);
        half3 result = min(sourceColor.rgb, secondSourceColor.rgb);
        result = clamp(result, 0.0, 1.0h);
        return half4(mix(secondSourceColor.rgb, result, sourceColor.a * opacity), 1.0h);
    }
    
    return secondSourceColor;
}

//差值 12
half4 DifferenceBlend(half4 secondSourceColor, half4 sourceColor, half opacity) {
    if (sourceColor.a > 0.0) {
        sourceColor.rgb = clamp(sourceColor.rgb / sourceColor.a, 0.0, 1.0h);
        half3 result = abs(sourceColor.rgb - secondSourceColor.rgb);
        result = clamp(result, 0.0, 1.0h);
        return half4(mix(secondSourceColor.rgb, result, sourceColor.a * opacity), 1.0h);
    }
    
    return secondSourceColor;
}

//排除 13
half4 ExclusionBlend(half4 secondSourceColor, half4 sourceColor, half opacity) {
    if (sourceColor.a > 0.0) {
        sourceColor.rgb = clamp(sourceColor.rgb / sourceColor.a, 0.0, 1.0h);
        half3 result = sourceColor.rgb + secondSourceColor.rgb - 2.0 * sourceColor.rgb * secondSourceColor.rgb;
        result = clamp(result, 0.0, 1.0h);
        return half4(mix(secondSourceColor.rgb, result, sourceColor.a * opacity), 1.0h);
    }
    
    return secondSourceColor;
}

half4 OverlayBlend(half4 secondSourceColor, half4 sourceColor, half opacity) {
    if (sourceColor.a > 0.0) {
        sourceColor.rgb = clamp(sourceColor.rgb / sourceColor.a, 0.0, 1.0h);
        float ra;
        if (secondSourceColor.r <= 0.5) {
            
            ra = 2.0 * sourceColor.r * secondSourceColor.r;
        } else {
            ra = 1.0 - 2.0 * (1.0 - sourceColor.r) * (1.0 - secondSourceColor.r);
        }
        
        float ga;
        if (secondSourceColor.g <= 0.5) {
            
            ga = 2.0 * sourceColor.g * secondSourceColor.g;
        } else {
            ga = 1.0 - 2.0 * (1.0 - sourceColor.g) * (1.0 - secondSourceColor.g);
        }
        
        float ba;
        if (secondSourceColor.b <= 0.5) {
            
            ba = 2.0 * sourceColor.b * secondSourceColor.b;
        } else {
            ba = 1.0 - 2.0 * (1.0 - sourceColor.b) * (1.0 - secondSourceColor.b);
        }
        
        half3 result = half3(ra, ga, ba);
        result = clamp(result, 0.0, 1.0h);
        return half4(mix(secondSourceColor.rgb, result, sourceColor.a * opacity), 1.0h);
    }
    
    return secondSourceColor;
}


fragment half4 MIBlendFragmentShader(MITwoInputVertexData in [[stage_in]],
                                     texture2d<half> inputTexture [[ texture(0) ]],
                                     texture2d<half> secondTexture [[ texture(1) ]],
                                     constant int *blendModes [[ buffer(0) ]],
                                     constant float *intensitys [[ buffer(1) ]] ) {
    constexpr sampler inputSampler (mag_filter::linear, min_filter::linear);
    
    half4 outputColor = inputTexture.sample (inputSampler, in.textureCoordinate);
    half4 secondoutputColor = secondTexture.sample (inputSampler, in.secondTextureCoordinate);
    
    int blendMode = blendModes[0];
    half intensity = intensitys[0];

    switch (blendMode) {
        case 0:
            outputColor = NormalBlend(outputColor, secondoutputColor, intensity);
            break;
        case 1:
            outputColor = MultiplyBlend(outputColor, secondoutputColor, intensity);
            break;
        case 2:
            outputColor = ScreenBlend(outputColor, secondoutputColor, intensity);
            break;
        case 3:
            outputColor = HardLightBlend(outputColor, secondoutputColor, intensity);
            break;
        case 4:
            outputColor = LightenBlend(outputColor, secondoutputColor, intensity);
            break;
        case 5:
            outputColor = LinearLightBlend(outputColor, secondoutputColor, intensity);
            break;
        case 6:
            outputColor = ColorDodgeBlend(outputColor, secondoutputColor, intensity);
            break;
        case 7:
            outputColor = SoftLightBlend(outputColor, secondoutputColor, intensity);
            break;
        case 8:
            outputColor = VividLightBlend(outputColor, secondoutputColor, intensity);
            break;
        case 9:
            outputColor = LinearBurnBlend(outputColor, secondoutputColor, intensity);
            break;
        case 10:
            outputColor = ColorBurnBlend(outputColor, secondoutputColor, intensity);
            break;
        case 11:
            outputColor = DarkenBlend(outputColor, secondoutputColor, intensity);
            break;
        case 12:
            outputColor = DifferenceBlend(outputColor, secondoutputColor, intensity);
            break;
        case 13:
            outputColor = ExclusionBlend(outputColor, secondoutputColor, intensity);
            break;
        default:
            break;
    }
    
    return outputColor;
}
