//
//  MIContext.m
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIContext.h"
#import <simd/simd.h>

@interface MIContext ()
{
#if !TARGET_IPHONE_SIMULATOR
    CVMetalTextureCacheRef _CVMetalTextureCache;
#endif
}

@end

@implementation MIContext

static MIContext *_sharedContext = nil;

+ (MIContext *)sharedContext {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sharedContext) {
            _sharedContext = [[self alloc] init];
        }
    });
    return _sharedContext;
}

- (instancetype)init {
    if (self = [super init]) {
        _device = MTLCreateSystemDefaultDevice();
        _defaultLibrary = [_device newDefaultLibrary];
        
        NSURL *metalImageURL = [[NSBundle mainBundle] URLForResource:@"MetalImage" withExtension:@"bundle"];
        
        NSString *libraryFile;
        if (metalImageURL) {
            NSBundle *metalImageBundle = [NSBundle bundleWithURL:metalImageURL];
            libraryFile = [metalImageBundle pathForResource:@"MetalImage" ofType:@"metallib"];
        }
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:libraryFile]) {
            libraryFile = [[NSBundle bundleForClass:self.class] pathForResource:@"default" ofType:@"metallib"];
        }
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:libraryFile]) {
            NSError *libraryError;
            _metalImageLibrary = [_device newLibraryWithFile:libraryFile error:&libraryError];
            if (!_metalImageLibrary) {
                NSLog(@"Library error: %@", libraryError);
            }
        } else {
            NSLog(@"MetalImage use defaultLibrary");
            _metalImageLibrary = _defaultLibrary;
        }
        _commandQueue = [_device newCommandQueue];
        _imageProcessingQueue = dispatch_queue_create("com.MetalImage.imageProcessingQueue", NULL);
    }
    return self;
}

+ (void)performSynchronouslyOnImageProcessingQueue:(void (^)(void))block {
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label([MIContext sharedContext].imageProcessingQueue)) {
        block();
    } else {
        dispatch_sync([MIContext sharedContext].imageProcessingQueue, ^{
            block();
        });
    }
}

+ (void)performAsynchronouslyOnImageProcessingQueue:(void (^)(void))block {
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label([MIContext sharedContext].imageProcessingQueue)) {
        
        block();
    } else {
        dispatch_async([MIContext sharedContext].imageProcessingQueue, ^{
            block();
        });
    }
}

#if !TARGET_IPHONE_SIMULATOR
- (CVMetalTextureCacheRef)CVMetalTextureCache {
    if (!_CVMetalTextureCache) {
        CVMetalTextureCacheFlush(_CVMetalTextureCache, 0);
        CVReturn textureCacheError = CVMetalTextureCacheCreate(kCFAllocatorDefault,
                                                               NULL,
                                                               [MIContext sharedContext].device,
                                                               NULL,
                                                               &_CVMetalTextureCache);
        if (textureCacheError) {
            NSLog(@">> ERROR: CVMetalTextureCacheCreate");
            assert(0);
        }
    }
    return _CVMetalTextureCache;
}
#endif




#pragma mark - 创建管线及资源方法

+ (id<MTLRenderPipelineState>)createRenderPipelineStateWithVertexFunction:(NSString *)vertexFunction fragmentFunction:(NSString *)fragmentFunction {
    id<MTLFunction> vertexFunc = nil;
    id<MTLFunction> fragmentFunc = nil;
    
    vertexFunc = [[MIContext sharedContext].defaultLibrary newFunctionWithName:vertexFunction];
    
    if (!vertexFunc) {
        vertexFunc = [[MIContext sharedContext].metalImageLibrary newFunctionWithName:vertexFunction];
    }
    
    fragmentFunc = [[MIContext sharedContext].defaultLibrary newFunctionWithName:fragmentFunction];
    
    if (!fragmentFunc) {
        fragmentFunc = [[MIContext sharedContext].metalImageLibrary newFunctionWithName:fragmentFunction];
    }
    if (!vertexFunc) {
        NSLog(@"MetalImage Error : vertexFunction : %@ not fount",vertexFunction);
    }
    
    if (!fragmentFunc) {
        NSLog(@"MetalImage Error : fragmentFunction : %@ not fount",fragmentFunction);
    }
    
    MTLRenderPipelineDescriptor *pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    pipelineDescriptor.vertexFunction = vertexFunc;
    pipelineDescriptor.fragmentFunction = fragmentFunc;
    
    NSError *error = nil;
    id<MTLRenderPipelineState> pipeline = [[MIContext sharedContext].device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
    
    if (!pipeline) {
        NSLog(@"MetalImage Error : occurred when creating render pipeline state: %@", error);
    }
    
    return pipeline;
}

+ (id<MTLComputePipelineState>)createComputePipelineStateWithFunction:(NSString *)function {
    id<MTLFunction> func = [[MIContext sharedContext].defaultLibrary newFunctionWithName:function];
    
    if (!func) {
        func = [[MIContext sharedContext].metalImageLibrary newFunctionWithName:function];
    }
    
    if (!func) {
        NSLog(@"MetalImage Error : kernelFunction : %@ not fount", function);
        return nil;
    }

    NSError *error = nil;
    id<MTLComputePipelineState> computePipelineState = [[MIContext sharedContext].device newComputePipelineStateWithFunction:func error:&error];
    if (!computePipelineState) {
        NSLog(@"MetalImage Error : occurred when creating compute pipeline state: %@", error);
    }
    return computePipelineState;
}

+ (id<MTLBuffer>)createBufferWithLength:(NSUInteger)length {
    id<MTLBuffer> mtlBuffer = [[MIContext sharedContext].device newBufferWithLength:length options:MTLResourceCPUCacheModeDefaultCache];
    
    return mtlBuffer;
}

+ (void)updateBufferContent:(id<MTLBuffer>)buffer contentSize:(CGSize)contentSize outputFrame:(CGRect)outputFrame {
    if (!buffer || buffer.length < 4 * sizeof(vector_float4) || CGSizeEqualToSize(CGSizeZero, contentSize)) {
        return;
    }
    vector_float4 *bufferContent = buffer.contents;
    
    if (CGRectEqualToRect(outputFrame, CGRectZero)) {
        bufferContent[0] = vector4(-1.0f, -1.0f, 0.0f, 1.0f);
        bufferContent[1] = vector4( 1.0f, -1.0f, 0.0f, 1.0f);
        bufferContent[2] = vector4(-1.0f,  1.0f, 0.0f, 1.0f);
        bufferContent[3] = vector4( 1.0f,  1.0f, 0.0f, 1.0f);
        return;
    }
    
    float left   = outputFrame.origin.x / contentSize.width * 2.0 - 1.0;
    float right  = (outputFrame.origin.x + outputFrame.size.width) / contentSize.width * 2.0 - 1.0;
    float top    = (1.0 - outputFrame.origin.y / contentSize.height) * 2.0 - 1.0;
    float bottom = (1.0 - (outputFrame.origin.y + outputFrame.size.height) / contentSize.height) * 2.0 - 1.0;
    
    bufferContent[0] = vector4(left,  bottom, 0.0f, 1.0f);
    bufferContent[1] = vector4(right, bottom, 0.0f, 1.0f);
    bufferContent[2] = vector4(left,  top, 0.0f, 1.0f);
    bufferContent[3] = vector4(right, top, 0.0f, 1.0f);
}



@end
