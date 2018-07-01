//
//  MIMirrorFilter.h
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIFilter.h"

typedef NS_ENUM(NSUInteger, MIMirrorFilterOrientation) {
    MIMirrorFilterOrientationHorizontal = 0,
    MIMirrorFilterOrientationVertical,
};

@interface MIMirrorFilter : MIFilter

/**
 oriention default MIMirrorFilterOrientationHorizontal
 */
@property (nonatomic, assign) MIMirrorFilterOrientation orientation;

@end
