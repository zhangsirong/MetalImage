//
//  MIUIElement.m
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIUIElement.h"
#import "MITexture.h"
#import "MIContext.h"

@implementation MIUIElement

- (instancetype)initWithUIView:(UIView *)uiView {
    if (self = [self initWithCALayer:uiView.layer]) {
        _sourceView = uiView;
    }
    
    return self;
}

- (instancetype)initWithCALayer:(CALayer *)caLayer {
    if (self = [super init]) {
        _sourceLayer = caLayer;
        _outputTexture = [[MITexture alloc] initWithCALayer:_sourceLayer];
        self.outputFrame = CGRectMake(0, 0, _outputTexture.size.width, _outputTexture.size.height);
    }
    return self;
}

- (void)refresh {
    [self refreshAtTime:kCMTimeInvalid];
}

- (void)refreshAtTime:(CMTime)time {
    if (!self.isEnabled) {
        return;
    }
    
    [MIContext performSynchronouslyOnImageProcessingQueue:^{
        id<MTLCommandBuffer> commandBuffer = [[MIContext sharedContext].commandQueue commandBuffer];
        
        [_outputTexture setupContentWithCALayer:_sourceLayer];
        [self produceAtTime:time commandBuffer:commandBuffer];
        
        [commandBuffer commit];
        [commandBuffer waitUntilCompleted];
    }];
    
    
}

@end
