//
//  MICropFilter.m
//  MetalImage
//
//  Created by zsr on 2018/07/09.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MICropFilter.h"

@interface MICropFilter() {
    vector_float2 cropTextureCoordinates[4];
}

@end@implementation MICropFilter

- (instancetype)init {
    return [self initWithCropRegion:CGRectMake(0, 0, 1, 1)];
}

- (instancetype)initWithCropRegion:(CGRect)newCropRegion {
    if (self = [super init]) {
        self.cropRegion = newCropRegion;
    }
    return self;
}

- (void)setCropRegion:(CGRect)cropRegion {
    _cropRegion = cropRegion;
    [self calculateCropTextureCoordinates];
}

- (void)calculateCropTextureCoordinates {
    
}

@end
