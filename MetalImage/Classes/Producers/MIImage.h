//
//  MIImage.h
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIProducer.h"
#import <UIKit/UIKit.h>

@interface MIImage : MIProducer

- (instancetype)initWithUIImage:(UIImage *)image;

@property (nonatomic, strong) UIImage *sourceImage;

- (void)processingImage;


@end
