//
//  MIUIElement.h
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIProducer.h"
#import <UIKit/UIKit.h>

@interface MIUIElement : MIProducer
{
    UIView *_sourceView;
    CALayer *_sourceLayer;
}

- (instancetype)initWithUIView:(UIView *)uiView;
- (instancetype)initWithCALayer:(CALayer *)caLayer;

- (void)refresh;

- (void)refreshAtTime:(CMTime)time;


@end
