//
//  MISmoothToonFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MISmoothToonFilter.h"
#import "MIGaussianBlurFilter.h"
#import "MIToonFilter.h"

@implementation MISmoothToonFilter

- (instancetype)init {
    if (self = [super init]) {
        _blurFilter = [[MIGaussianBlurFilter alloc] init];
        _toonFilter = [[MIToonFilter alloc] init];
        
        [_allFiltersInGroup addObject:_blurFilter];
        [_allFiltersInGroup addObject:_toonFilter];
        
        self.headerFiltersInGroup = @[_blurFilter];
        self.endFilterInGroup = _toonFilter;
        
        [_blurFilter addConsumer:_toonFilter];
        
        self.blurRadiusInPixels = 2.0;
        self.threshold = 0.2;
        self.quantizationLevels = 10.0;
    }
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setBlurRadiusInPixels:(CGFloat)newValue {
    _blurFilter.blurRadiusInPixels = newValue;
}

- (CGFloat)blurRadiusInPixels {
    return _blurFilter.blurRadiusInPixels;
}

- (void)setTexelWidth:(CGFloat)newValue {
    _toonFilter.texelWidth = newValue;
}

- (CGFloat)texelWidth {
    return _toonFilter.texelWidth;
}

- (void)setTexelHeight:(CGFloat)newValue {
    _toonFilter.texelHeight = newValue;
}

- (CGFloat)texelHeight {
    return _toonFilter.texelHeight;
}

- (void)setThreshold:(CGFloat)newValue {
    _toonFilter.threshold = newValue;
}

- (CGFloat)threshold {
    return _toonFilter.threshold;
}

- (void)setQuantizationLevels:(CGFloat)newValue {
    _toonFilter.quantizationLevels = newValue;
}

- (CGFloat)quantizationLevels {
    return _toonFilter.quantizationLevels;
}

@end

