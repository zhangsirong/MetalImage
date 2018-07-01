//
//  MIFilterGroup.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIProducer.h"
#import "MIConsumer.h"

@interface MIFilterGroup : MIProducer<MIConsumer>
{
    NSMutableArray<MIProducer<MIConsumer> *> *_allFiltersInGroup;
    MITexture *_inputTexture;
    CGSize _contentSize;
}

@property (copy, nonatomic) NSArray<MIProducer<MIConsumer> *> *headerFiltersInGroup;
@property (strong, nonatomic) MIProducer<MIConsumer> *endFilterInGroup;

- (instancetype)initWithContentSize:(CGSize)contentSize;

@end
