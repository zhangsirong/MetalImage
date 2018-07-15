//
//  MIContext.h
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>

@interface MIContext : NSObject

@property (nonatomic, strong, readonly) id<MTLDevice> device;///<全局设置的，代表GPU
@property (nonatomic, strong, readonly) id<MTLLibrary> defaultLibrary;///<项目默认着色器库
@property (nonatomic, strong, readonly) id<MTLLibrary> metalImageLibrary;///<本Bundld对应的着色器库
@property (nonatomic, strong, readonly) id<MTLCommandQueue> commandQueue;///<渲染顶点，片段对应的队列
@property (nonatomic, strong, readonly) dispatch_queue_t imageProcessingQueue;

#if !TARGET_IPHONE_SIMULATOR
@property (nonatomic, readonly) CVMetalTextureCacheRef CVMetalTextureCache;
#endif

+ (MIContext *)sharedContext;
+ (void)performSynchronouslyOnImageProcessingQueue:(void (^)(void))block;
+ (void)performAsynchronouslyOnImageProcessingQueue:(void (^)(void))block;

+ (id<MTLBuffer>)createBufferWithLength:(NSUInteger)length;
    
+ (id<MTLRenderPipelineState>)createRenderPipelineStateWithVertexFunction:(NSString *)vertexFunction
                                                         fragmentFunction:(NSString *)fragmentFunction;
    
+ (id<MTLRenderPipelineState>)createRenderPipelineStateWithVertexFunction:(NSString *)vertexFunction
                                                         fragmentFunction:(NSString *)fragmentFunction
                                                                inLibrary:(id<MTLLibrary>)library;
    
+ (id<MTLComputePipelineState>)createComputePipelineStateWithFunction:(NSString *)function;
+ (id<MTLComputePipelineState>)createComputePipelineStateWithFunction:(NSString *)function inLibrary:(id<MTLLibrary>)library;

+ (void)updateBufferContent:(id<MTLBuffer>)buffer contentSize:(CGSize)contentSize outputFrame:(CGRect)outputFrame;


@end
