//
//  MILookupTableFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"
/* 生成原始直方图
    MITexture *texture = [[MITexture alloc] initWithSize:CGSizeMake(64, 64)];
    uint8_t total[64 * 64 * 4];
    int dataOffset = 0;
    for (int j = 0; j < 64; ++j) {
        for (int i = 0; i < 64; ++i) {
            int r = i % 16;
            int g = j % 16;
            int b = i / 16 + (j / 16) * 4;
            total[dataOffset] = (int)(b * 255.0 / 15.0 + 0.5);
            total[dataOffset+1] = (int)(g * 255.0 / 15.0 + 0.5);
            total[dataOffset+2] = (int)(r * 255.0 / 15.0 + 0.5);
            total[dataOffset+3] = 255;
            dataOffset += 4;
        }
    }
    MTLRegion region = MTLRegionMake2D(0, 0, 64, 64);
    [texture.mtlTexture replaceRegion:region mipmapLevel:0 withBytes:total bytesPerRow:sizeof(uint8_t) * 4 * 64];
    UIImage *image = [texture imageFromMTLTexture];
 */

@interface MILookupTableFilter : MIFilter

//0 ~ 1.0
@property (nonatomic, readwrite) float intensity;

- (void)updateLookupTableImage:(UIImage *)table;

@end
