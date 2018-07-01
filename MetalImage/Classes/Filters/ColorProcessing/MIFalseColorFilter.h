//
//  MIFalseColorFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

@interface MIFalseColorFilter : MIFilter
{
    id<MTLBuffer> _firstColorBuffer;
    id<MTLBuffer> _secondColorBuffer;
}
@property (nonatomic) vector_float4 firstColor;
@property (nonatomic) vector_float4 secondColor;

- (void)setFirstColorRed:(float)redComponent green:(float)greenComponent blue:(float)blueComponent;
- (void)setSecondColorRed:(float)redComponent green:(float)greenComponent blue:(float)blueComponent;

@end
