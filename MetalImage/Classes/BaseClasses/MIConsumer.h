//
//  MIConsumer.h
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <Metal/Metal.h>

@class MITexture;
@protocol MIConsumer <NSObject>

@required
@property (nonatomic, readwrite, getter=isEnabled) BOOL enabled;
@property (nonatomic, readwrite) CGSize contentSize;

- (void)setInputTexture:(MITexture *)inputTexture;
- (void)renderRect:(CGRect)rect atTime:(CMTime)time commandBuffer:(id<MTLCommandBuffer>)commandBuffer;

@optional
- (UIImage *)imageFromCurrentFrame;

@end

