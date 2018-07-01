//
//  MICrosshatchFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

@interface MICrosshatchFilter : MIFilter

// The fractional width of the image to use as the spacing for the crosshatch. The default is 0.03.

@property(nonatomic, assign) float crossHatchSpacing;
// A relative width for the crosshatch lines. The default is 0.003.
@property(nonatomic, assign) float lineWidth;


@end
