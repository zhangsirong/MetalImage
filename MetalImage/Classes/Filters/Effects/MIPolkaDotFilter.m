//
//  MIPolkaDotFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIPolkaDotFilter.h"

@interface MIPolkaDotFilter ()
{
    id<MTLBuffer> _dotScalingBuffer;
}
@end

@implementation MIPolkaDotFilter


- (instancetype)init {
    if (self = [super init]) {
        _dotScalingBuffer = [[MIContext sharedContext].device newBufferWithLength:sizeof(float) options:MTLResourceOptionCPUCacheModeDefault];
        
        self.dotScaling = 0.9;
    }
    return self;
}

- (void)setDotScaling:(float)dotScaling {
    _dotScaling = dotScaling;
    float *dotScalings = _dotScalingBuffer.contents;
    dotScalings[0] = dotScaling;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_dotScalingBuffer offset:0 atIndex:3];
}

+ (NSString *)fragmentShaderFunction {
    static NSString *fFunction = @"MIPolkaDotFragmentShader";
    return fFunction;
}

@end
