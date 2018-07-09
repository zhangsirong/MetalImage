//
//  MIFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIProducer.h"
#import "MIConsumer.h"
#import "MIContext.h"
#import "MITexture.h"

@interface MIFilter : MIProducer <MIConsumer> {
    MITexture *_inputTexture;
    id<MTLRenderPipelineState> _renderPipelineState;
    MTLRenderPassDescriptor *_renderPassDescriptor;
    
    id<MTLBuffer> _positionBuffer;
    CGRect _preRenderRect;
}

@property (nonatomic, readwrite) CGSize contentSize;
@property (nonatomic, readwrite) MTLClearColor clearColor;

- (instancetype)initWithContentSize:(CGSize)contentSize;

+ (NSString *)vertexShaderFunction;
+ (NSString *)fragmentShaderFunction;

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder;

@end

