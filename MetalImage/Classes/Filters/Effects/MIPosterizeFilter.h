//
//  MIPosterizeFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

@interface MIPosterizeFilter : MIFilter
{
    id<MTLBuffer> _colorLevelsBuffer;
}
/** The number of color levels to reduce the image space to. This ranges from 1 to 256, with a default of 10.
 */
@property (nonatomic) int colorLevels;

@end
