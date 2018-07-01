//
//  MIGaussianBlurFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIGaussianBlurFilter.h"

@implementation MIGaussianBlurFilter

- (instancetype)init {
    if (self = [super init]) {
        
        _blurCountBuffer = [MIContext createBufferWithLength:sizeof(int)];
        _offsetFromCenterBuffer = [MIContext createBufferWithLength:8 * sizeof(float)];
        _optimizedWeightBuffer = [MIContext createBufferWithLength:8 * sizeof(float)];
        
        self.texelSpacingMultiplier = 1.0;
        self.blurRadiusInPixels = 4.0;
        _shouldResizeBlurRadiusWithImageSize = NO;
    }
    return self;
}

- (void)setBlurRadiusInPixels:(float)blurRadiusInPixels {
    if (round(blurRadiusInPixels) != _blurRadiusInPixels)//取小数点后面2位
    {
        _blurRadiusInPixels = round(blurRadiusInPixels); // For now, only do integral sigmas
        
        int calculatedSampleRadius = 0;
        if (_blurRadiusInPixels >= 1) // Avoid a divide-by-zero error here
        {
            // Calculate the number of pixels to sample from by setting a bottom limit for the contribution of the outermost pixel
            float minimumWeightToFindEdgeOfSamplingArea = 1.0/256.0;
            calculatedSampleRadius = floor(sqrt(-2.0 * pow(_blurRadiusInPixels, 2.0) * log(minimumWeightToFindEdgeOfSamplingArea * sqrt(2.0 * M_PI * pow(_blurRadiusInPixels, 2.0))) ));
            calculatedSampleRadius += calculatedSampleRadius % 2; // There's nothing to gain from handling odd radius sizes, due to the optimizations I use
        }
        
        NSLog(@"Blur radius: %f, calculated sample radius: %d", _blurRadiusInPixels, calculatedSampleRadius);
        
        [self setupVertexBufferWithBlurRadius:calculatedSampleRadius sigma:_blurRadiusInPixels];
        [self setupFragmentBufferWithBlurRadius:calculatedSampleRadius sigma:_blurRadiusInPixels];
    }
}

- (void)setTexelSpacingMultiplier:(float)newValue {
    _texelSpacingMultiplier = newValue;
    
    _verticalTexelSpacing = _texelSpacingMultiplier;
    _horizontalTexelSpacing = _texelSpacingMultiplier;
    
    [self setupFilterForSize:CGSizeMake(750, 1000)];
}

- (void)setupFilterForSize:(CGSize)filterFrameSize {
    [super setupFilterForSize:filterFrameSize];
    if (_shouldResizeBlurRadiusWithImageSize) {
        if (self.blurRadiusAsFractionOfImageWidth > 0)
        {
            self.blurRadiusInPixels = filterFrameSize.width * self.blurRadiusAsFractionOfImageWidth;
        } else {
            self.blurRadiusInPixels = filterFrameSize.height * self.blurRadiusAsFractionOfImageHeight;
        }
    }
}

- (void)setBlurRadiusAsFractionOfImageWidth:(float)blurRadiusAsFractionOfImageWidth {
    if (blurRadiusAsFractionOfImageWidth < 0)  return;
    
    _shouldResizeBlurRadiusWithImageSize = _blurRadiusAsFractionOfImageWidth != blurRadiusAsFractionOfImageWidth && blurRadiusAsFractionOfImageWidth > 0;
    _blurRadiusAsFractionOfImageWidth = blurRadiusAsFractionOfImageWidth;
    _blurRadiusAsFractionOfImageHeight = 0;
}

- (void)setBlurRadiusAsFractionOfImageHeight:(float)blurRadiusAsFractionOfImageHeight {
    if (blurRadiusAsFractionOfImageHeight < 0)  return;
    
    _shouldResizeBlurRadiusWithImageSize = _blurRadiusAsFractionOfImageHeight != blurRadiusAsFractionOfImageHeight && blurRadiusAsFractionOfImageHeight > 0;
    _blurRadiusAsFractionOfImageHeight = blurRadiusAsFractionOfImageHeight;
    _blurRadiusAsFractionOfImageWidth = 0;
}

- (void)setupVertexBufferWithBlurRadius:(int)blurRadius sigma:(float)sigma {
    int *blurCounts = _blurCountBuffer.contents;
    
    if (blurRadius < 1) {
        blurCounts[0] = 1;
        return;
    }
    blurCounts[0] = MIN(blurRadius / 2, blurRadius) + 1;
    
    float *standardGaussianWeights = calloc(blurRadius + 1, sizeof(float));
    float sumOfWeights = 0.0;
    for (NSUInteger currentGaussianWeightIndex = 0; currentGaussianWeightIndex < blurRadius + 1; currentGaussianWeightIndex++)
    {
        standardGaussianWeights[currentGaussianWeightIndex] = (1.0 / sqrtf(2.0 * M_PI * powf(sigma, 2.0))) * expf(-powf(currentGaussianWeightIndex, 2.0) / (2.0 * powf(sigma, 2.0)));
        
        if (currentGaussianWeightIndex == 0) {
            sumOfWeights += standardGaussianWeights[currentGaussianWeightIndex];
        }
        else
        {
            sumOfWeights += 2.0 * standardGaussianWeights[currentGaussianWeightIndex];
        }
    }
    
    // Next, normalize these weights to prevent the clipping of the Gaussian curve at the end of the discrete samples from reducing luminance
    for (NSUInteger currentGaussianWeightIndex = 0; currentGaussianWeightIndex < blurRadius + 1; currentGaussianWeightIndex++)
    {
        standardGaussianWeights[currentGaussianWeightIndex] = standardGaussianWeights[currentGaussianWeightIndex] / sumOfWeights;
    }
    
    // From these weights we calculate the offsets to read interpolated values from
    NSUInteger numberOfOptimizedOffsets = MIN(blurRadius / 2 + (blurRadius % 2), 7);
    
    float *offsetFromCenters = _offsetFromCenterBuffer.contents;
    
    for (int currentOptimizedOffset = 0; currentOptimizedOffset < numberOfOptimizedOffsets; currentOptimizedOffset++)
    {
        float firstWeight = standardGaussianWeights[currentOptimizedOffset * 2 + 1];
        float secondWeight = standardGaussianWeights[currentOptimizedOffset * 2 + 2];
        
        float optimizedWeight = firstWeight + secondWeight;
        
        offsetFromCenters[currentOptimizedOffset + 1] = (firstWeight * (currentOptimizedOffset*2 + 1) + secondWeight * (currentOptimizedOffset * 2 + 2)) / optimizedWeight;
    }
    
    free(standardGaussianWeights);
}

- (void)setupFragmentBufferWithBlurRadius:(int)blurRadius sigma:(float)sigma {
    int *blurCounts = _blurCountBuffer.contents;
    
    if (blurRadius < 1) {
        blurCounts[0] = 1;
        return;
    }
    
    blurCounts[0] = MIN(blurRadius / 2, blurRadius) + 1;
    
    float *standardGaussianWeights = calloc(blurRadius + 1, sizeof(float));
    float sumOfWeights = 0.0;
    for (NSUInteger currentGaussianWeightIndex = 0; currentGaussianWeightIndex < blurRadius + 1; currentGaussianWeightIndex++)
    {
        standardGaussianWeights[currentGaussianWeightIndex] = (1.0 / sqrtf(2.0 * M_PI * powf(sigma, 2.0))) * expf(-powf(currentGaussianWeightIndex, 2.0) / (2.0 * powf(sigma, 2.0)));
        
        if (currentGaussianWeightIndex == 0) {
            sumOfWeights += standardGaussianWeights[currentGaussianWeightIndex];
        }
        else
        {
            sumOfWeights += 2.0 * standardGaussianWeights[currentGaussianWeightIndex];
        }
    }
    
    // Next, normalize these weights to prevent the clipping of the Gaussian curve at the end of the discrete samples from reducing luminance
    for (NSUInteger currentGaussianWeightIndex = 0; currentGaussianWeightIndex < blurRadius + 1; currentGaussianWeightIndex++)
    {
        standardGaussianWeights[currentGaussianWeightIndex] = standardGaussianWeights[currentGaussianWeightIndex] / sumOfWeights;
    }
    
    // From these weights we calculate the offsets to read interpolated values from
    NSUInteger numberOfOptimizedOffsets = MIN(blurRadius / 2 + (blurRadius % 2), 7);
    
    float *optimizedWeights = _optimizedWeightBuffer.contents;
    optimizedWeights[0] = standardGaussianWeights[0];
    
    for (int currentOptimizedOffset = 0; currentOptimizedOffset < numberOfOptimizedOffsets; currentOptimizedOffset++)
    {
        float firstWeight = standardGaussianWeights[currentOptimizedOffset * 2 + 1];
        float secondWeight = standardGaussianWeights[currentOptimizedOffset * 2 + 2];
        
        float optimizedWeight = firstWeight + secondWeight;
        
        optimizedWeights[currentOptimizedOffset + 1] = optimizedWeight;
    }
    
    free(standardGaussianWeights);
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setVertexBuffer:_blurCountBuffer offset:0 atIndex:4];
    [commandEncoder setVertexBuffer:_offsetFromCenterBuffer offset:0 atIndex:5];
    
    [commandEncoder setFragmentBuffer:_blurCountBuffer offset:0 atIndex:1];
    [commandEncoder setFragmentBuffer:_optimizedWeightBuffer offset:0 atIndex:2];
}

- (void)setSecondVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setSecondVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setVertexBuffer:_blurCountBuffer offset:0 atIndex:4];
    [commandEncoder setVertexBuffer:_offsetFromCenterBuffer offset:0 atIndex:5];
    
    [commandEncoder setFragmentBuffer:_blurCountBuffer offset:0 atIndex:1];
    [commandEncoder setFragmentBuffer:_optimizedWeightBuffer offset:0 atIndex:2];
}

+ (NSString *)vertexShaderFunction {
    NSString *function = @"MIGaussianBlurVertexShader";
    return function;
}

+ (NSString *)fragmentShaderFunction {
    NSString *function = @"MIGaussianBlurFragmentShader";
    return function;
}

+ (NSString *)secondVertexShaderFunction {
    NSString *function = @"MIGaussianBlurVertexShader";
    return function;
}

+ (NSString *)secondFragmentShaderFunction {
    NSString *function = @"MIGaussianBlurFragmentShader";
    return function;
}


@end
