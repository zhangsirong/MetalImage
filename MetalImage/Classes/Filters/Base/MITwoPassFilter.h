//
//  MITwoPassFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

@interface MITwoPassFilter : MIFilter
{
    id<MTLRenderPipelineState> _secondRenderPipelineState;
    MTLRenderPassDescriptor *_secondpassDescriptor;

    MITexture *_firstOutputTexture;
}

- (void)setSecondVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder;

+ (NSString *)secondVertexShaderFunction;
+ (NSString *)secondFragmentShaderFunction;

@end
