//
//  MITexture.h
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <QuartzCore/QuartzCore.h>
#import <simd/simd.h>
#import <UIKit/UIKit.h>

@interface MITexture : NSObject

typedef NS_ENUM(NSInteger, MITextureOrientation) {
    MITextureOrientationUp = 0,
    MITextureOrientationDown,
    MITextureOrientationLeft,
    MITextureOrientationRight,
    MITextureOrientationUpMirrored,
    MITextureOrientationDownMirrored,
    MITextureOrientationLeftMirrored,
    MITextureOrientationRightMirrored
};

@property (nonatomic, strong) id<MTLTexture> mtlTexture;
@property (nonatomic, readonly) CGSize size;
@property (nonatomic, assign) MITextureOrientation orientation;
@property (nonatomic, readonly) id<MTLBuffer> textureCoordinateBuffer;

- (instancetype)initWithSize:(CGSize)size;
- (instancetype)initWithCVBuffer:(CVBufferRef)CVBuffer;
- (instancetype)initWithUIImage:(UIImage *)image;
- (instancetype)initWithCGImage:(CGImageRef)image;
- (instancetype)initWithCALayer:(CALayer *)caLayer;
- (instancetype)initWithSize:(CGSize)size orientation:(MITextureOrientation)orientation;
- (instancetype)initWithCVBuffer:(CVBufferRef)CVBuffer orientation:(MITextureOrientation)orientation;
- (instancetype)initWithCGImage:(CGImageRef)image orientation:(MITextureOrientation)orientation;
- (instancetype)initWithUIImage:(UIImage *)image orientation:(MITextureOrientation)orientation;

- (void)setupContentWithSize:(CGSize)size;
- (void)setupContentWithCVBuffer:(CVBufferRef)CVBuffer;
- (void)setupContentWithCGImage:(CGImageRef)image;
- (void)setupContentWithUIImage:(UIImage *)image;
- (void)setupContentWithCALayer:(CALayer *)caLayer;

- (UIImage *)imageFromMTLTexture;

@end
