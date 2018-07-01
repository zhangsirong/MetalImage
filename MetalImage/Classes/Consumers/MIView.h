//
//  MIView.h
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIContext.h"
#import "MIConsumer.h"
#import "MITexture.h"

@interface MIView : UIView <MIConsumer>
{
    MITexture *_inputTexture;
    id<MTLRenderPipelineState> _renderPipelineState;
    MTLRenderPassDescriptor *_passDescriptor;
    id<MTLBuffer> _positionBuffer;
    CGRect _preRenderRect;
    MTLClearColor _clearColor;
    BOOL _layerSizeDidUpdate;
    
#if !TARGET_IPHONE_SIMULATOR
    CAMetalLayer *_metalLayer;
#endif
}

@property (nonatomic, readwrite, assign) CGSize contentSize;
@property (nonatomic, readwrite, getter=isEnabled) BOOL enabled;

@end
