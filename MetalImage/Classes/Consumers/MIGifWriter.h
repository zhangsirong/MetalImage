//
//  MIGifWriter.h
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIConsumer.h"

@class MIGifWriter;
@protocol MIGIFWriterDelegate <NSObject>

- (void)gifWriterDidFinishWriting:(MIGifWriter *)gifWriter;
- (void)gifWriter:(MIGifWriter *)gifWriter didAddImageWithIndex:(NSInteger)index;///<已经添加到第几张的GIF

@end

@interface MIGifWriter : NSObject <MIConsumer>
{
    MITexture *_inputTexture;
    id<MTLRenderPipelineState> _renderPipelineState;
    MTLRenderPassDescriptor *_renderPassDescriptor;
    
    id<MTLBuffer> _positionBuffer;
    MITexture *_outputTexture;
    CGRect _preRenderRect;
    NSMutableArray<UIImage *> *_images;
    
    NSInteger _recordedFrameCount;
    CMTime _frameTime;
}

@property (nonatomic, weak) id<MIGIFWriterDelegate> delegate;
@property (nonatomic, readwrite) CGSize contentSize;
@property (nonatomic, readwrite, getter=isEnabled) BOOL enabled;
@property (nonatomic, strong) NSURL *outputURL;
@property (nonatomic, assign) UIDeviceOrientation orientation;
@property (nonatomic, assign) int maxFrame;

- (instancetype)initWithContentSize:(CGSize)contentSize outputURL:(NSURL *)outputURL maxFrame:(int)maxFrame;

- (void)finishWriting;


@end
