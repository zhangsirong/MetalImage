//
//  MIMirrorFilter.m
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIMirrorFilter.h"

@interface MIMirrorFilter ()
{
    id<MTLBuffer> _orientationBuffer;
}
@end


@implementation MIMirrorFilter

- (instancetype)init {
    if (self = [super init]) {
        _orientationBuffer = [MIContext createBufferWithLength:sizeof(int)];
        self.orientation = MIMirrorFilterOrientationHorizontal;
    }
    return self;
}

- (void)setOrientation:(MIMirrorFilterOrientation)orientation {
    _orientation = orientation;
    int *orientations = _orientationBuffer.contents;
    orientations[0] = orientation;
}

- (void)setVertexFragmentBufferOrTexture:(id<MTLRenderCommandEncoder>)commandEncoder {
    [super setVertexFragmentBufferOrTexture:commandEncoder];
    [commandEncoder setFragmentBuffer:_orientationBuffer offset:0 atIndex:0];
}

+ (NSString *)fragmentShaderFunction {
    static NSString *fFunction = @"MIMirrorFragmentShader";
    return fFunction;
}


@end
