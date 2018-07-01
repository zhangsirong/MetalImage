//
//  MIView.m
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIView.h"

@implementation MIView

#if !TARGET_IPHONE_SIMULATOR
+ (Class)layerClass {
    return [CAMetalLayer class];
}
#endif

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        
        _renderPipelineState = [MIContext createRenderPipelineStateWithVertexFunction:@"MIDefaultVertexShader"
                                                                     fragmentFunction:@"MIDefaultFragmentShader"];
        
        self.contentSize = CGSizeMake(frame.size.width * [UIScreen mainScreen].nativeScale, frame.size.height * [UIScreen mainScreen].nativeScale);
        
#if !TARGET_IPHONE_SIMULATOR
        _metalLayer = (CAMetalLayer *)self.layer;
        _metalLayer.device = [MIContext sharedContext].device;
        _metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;
        _metalLayer.framebufferOnly = YES;
        
        if(_layerSizeDidUpdate){
            _metalLayer.drawableSize = self.contentSize;
            _layerSizeDidUpdate = NO;
        }
#endif
        self.enabled = YES;
        _passDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
        _clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1.0);
    }
    return self;
}

- (void)setContentScaleFactor:(CGFloat)contentScaleFactor {
    [super setContentScaleFactor:contentScaleFactor];
    _layerSizeDidUpdate = YES;
}

- (void)setInputTexture:(MITexture *)inputTexture {
    _inputTexture = inputTexture;
}

- (void)renderRect:(CGRect)rect atTime:(CMTime)time commandBuffer:(id<MTLCommandBuffer>)commandBuffer {
    if (!_inputTexture || !self.isEnabled) {
        return;
    }
    if (!_positionBuffer) {
        _positionBuffer = [MIContext createBufferWithLength:4 * sizeof(vector_float4)];
    }
    
    if (!CGRectEqualToRect(rect, _preRenderRect)) {
        _preRenderRect = rect;
        [MIContext updateBufferContent:_positionBuffer contentSize:self.contentSize outputFrame:rect];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    id<CAMetalDrawable> drawable = [_metalLayer nextDrawable];
    id<MTLTexture> framebufferTexture = drawable.texture;
    
    if (drawable) {
        _passDescriptor.colorAttachments[0].texture = framebufferTexture;
        _passDescriptor.colorAttachments[0].clearColor = _clearColor;
        _passDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
        _passDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
        
        id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:_passDescriptor];
        [commandEncoder setRenderPipelineState:_renderPipelineState];
        [commandEncoder setViewport:(MTLViewport){0, 0, self.contentSize.width, self.contentSize.height, -1.0, 1.0}];
        
        [commandEncoder setVertexBuffer:_positionBuffer offset:0 atIndex:0];
        [commandEncoder setVertexBuffer:_inputTexture.textureCoordinateBuffer offset:0 atIndex:1];
        
        [commandEncoder setFragmentTexture:_inputTexture.mtlTexture atIndex:0];
        [commandEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip vertexStart:0 vertexCount:4];
        [commandEncoder endEncoding];
        
        [commandBuffer presentDrawable:drawable];
    }
#endif
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    CGFloat red, green, blue, alpha;
    [self.backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
    _clearColor = MTLClearColorMake(red, green, blue, alpha);
}
@end
