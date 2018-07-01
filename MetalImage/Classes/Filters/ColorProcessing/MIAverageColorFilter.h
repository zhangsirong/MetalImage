//
//  MIAverageColorFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

/**
 未完成
 */
@interface MIAverageColorFilter : MIFilter
{
    id<MTLBuffer> _texelWidthBuffer;
    id<MTLBuffer> _texelHeightBuffer;
    
    NSUInteger _numberOfStages;
    
    uint8_t *_rawImagePixels;
    CGSize _finalStageSize;
    
    MITexture *_currentTexture;
    MITexture *_currentTexture1;
    MITexture *_currentTexture2;
    MITexture *_currentTexture3;
    
}



@end
