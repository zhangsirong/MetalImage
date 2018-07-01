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

@property (nonatomic, strong, readonly) id<MTLDevice> device;
@property (nonatomic, strong, readonly) id<MTLLibrary> defaultLibrary;
@property (nonatomic, strong, readonly) id<MTLLibrary> metalImageLibrary;
@property (nonatomic, strong, readonly) id<MTLCommandQueue> commandQueue;
@property (nonatomic, strong, readonly) id<MTLCommandQueue> camputerCommandQueue;

@property (nonatomic, strong, readonly) dispatch_queue_t imageProcessingQueue;

#if !TARGET_IPHONE_SIMULATOR
@property (nonatomic, readonly) CVMetalTextureCacheRef CVMetalTextureCache;
#endif

+ (MIContext *)sharedContext;
+ (void)performSynchronouslyOnImageProcessingQueue:(void (^)(void))block;
+ (void)performAsynchronouslyOnImageProcessingQueue:(void (^)(void))block;

+ (id<MTLBuffer>)createBufferWithLength:(NSUInteger)length;
+ (id<MTLRenderPipelineState>)createRenderPipelineStateWithVertexFunction:(NSString *)vertexFunction fragmentFunction:(NSString *)fragmentFunction;
+ (void)updateBufferContent:(id<MTLBuffer>)buffer contentSize:(CGSize)contentSize outputFrame:(CGRect)outputFrame;


@end
