//
//  MICropFilter.h
//  MetalImage
//
//  Created by zsr on 2018/07/09.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

/**
 contentSize裁剪过后的尺寸
 */
@interface MICropFilter : MIFilter

 @property (nonatomic, readwrite) CGRect cropRegion;
    
- (instancetype)initWithCropRegion:(CGRect)newCropRegion;
    
@end
