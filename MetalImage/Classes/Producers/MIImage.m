//
//  MIImage.m
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIImage.h"
#import "MIImage.h"
#import "MITexture.h"
#import "MIContext.h"

@implementation MIImage

- (instancetype)initWithUIImage:(UIImage *)image {
    if (self = [self init]) {
        self.sourceImage = image;
    }
    return self;
}

- (void)setSourceImage:(UIImage *)sourceImage {
    if (_sourceImage != sourceImage) {
        _sourceImage = sourceImage;
        _outputTexture = [[MITexture alloc] initWithUIImage:_sourceImage];
        self.outputFrame = CGRectMake(0, 0, _outputTexture.size.width, _outputTexture.size.height);
    }
}

- (void)processingImage {
    id<MTLCommandBuffer> commandBuffer = [[MIContext sharedContext].commandQueue commandBuffer];
    [self produceAtTime:kCMTimeInvalid commandBuffer:commandBuffer];
    [commandBuffer commit];
    
    [commandBuffer waitUntilCompleted];
}

@end
