//
//  MIStretchDistortionFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

@interface MIStretchDistortionFilter : MIFilter
{
    id<MTLBuffer> _centerBuffer;
}
/** The center about which to apply the distortion, with a default of (0.5, 0.5)
 */
@property (nonatomic) CGPoint center;

@end

