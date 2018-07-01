//
//  MISphereRefractionFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

@interface MISphereRefractionFilter : MIFilter
{
    id<MTLBuffer> _aspectRatioBuffer;
    id<MTLBuffer> _centerBuffer;
    id<MTLBuffer> _radiusBuffer;
    id<MTLBuffer> _refractiveIndexBuffer;
}
/** The center about which to apply the distortion, with a default of (0.5, 0.5)
 */
@property (nonatomic) CGPoint center;
/** The radius of the distortion, ranging from 0.0 to 1.0, with a default of 0.25
 */
@property (nonatomic) float radius;
/** The index of refraction for the sphere, with a default of 0.71
 */
@property (nonatomic) float refractiveIndex;


@end
