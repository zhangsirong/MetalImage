//
//  MIFilterGroup.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilterGroup.h"

@implementation MIFilterGroup

- (instancetype)init {
    if (self = [super init]) {
        _allFiltersInGroup = [NSMutableArray array];
        _headerFiltersInGroup = [NSArray array];
    }
    return self;
}

- (instancetype)initWithContentSize:(CGSize)contentSize {
    if (self = [self init]) {
        self.contentSize = contentSize;
    }
    return self;
}

- (void)setContentSize:(CGSize)contentSize {
    _contentSize = contentSize;
    for (MIProducer<MIConsumer> *filter in _allFiltersInGroup) {
        filter.contentSize = contentSize;
    }
}

- (CGSize)contentSize {
    return _contentSize;
}

- (void)setInputTexture:(MITexture *)inputTexture {
    _inputTexture = inputTexture;
    for (MIProducer<MIConsumer> *filter in _headerFiltersInGroup) {
        [filter setInputTexture:inputTexture];
    }
}

- (void)addConsumer:(id<MIConsumer>)consumer {
    [self.endFilterInGroup addConsumer:consumer];
}

- (void)renderRect:(CGRect)rect atTime:(CMTime)time commandBuffer:(id<MTLCommandBuffer>)commandBuffer {
    for (MIProducer<MIConsumer> *filter in _headerFiltersInGroup) {
        [filter renderRect:rect atTime:time commandBuffer:commandBuffer];
    }
}

- (void)removeAllConsumers {
    [self.endFilterInGroup removeAllConsumers];
}

- (void)setOutputFrame:(CGRect)outputFrame {
    [self.endFilterInGroup setOutputFrame:outputFrame];
}

@end
