//
//  MIShowCaseFilterViewController.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MIShowCaseFilterType) {
    MIShowCaseFilterTypeMirror = 0,
    MIShowCaseFilterTypeLookupTable,
    MIShowCaseFilterTypePixellation,
    MIShowCaseFilterTypeHalftone,
    MIShowCaseFilterTypeCrosshatch,
    MIShowCaseFilterTypeEmboss,
    MIShowCaseFilterTypePerlinNoise,
    MIShowCaseFilterTypePixellatePosition,
    MIShowCaseFilterTypePolarPixellate,
    MIShowCaseFilterTypePolkaDot,
    MIShowCaseFilterTypeSketch,
    MIShowCaseFilterTypeThresholdSketch,
    MIShowCaseFilterTypeToon,
    MIShowCaseFilterTypeSmoothToon,
    MIShowCaseFilterTypeCGAColorspace,
    MIShowCaseFilterTypePosterize,
    MIShowCaseFilterTypeSwirl,
    MIShowCaseFilterTypeBulgeDistortion,
    MIShowCaseFilterTypePinchDistortion,
    MIShowCaseFilterTypeStretchDistortion,
    MIShowCaseFilterTypeSphereRefraction,
    MIShowCaseFilterTypeGlassSphere,
    MIShowCaseFilterTypeKuwahara,
    MIShowCaseFilterTypeKuwaharaRadius3,
    MIShowCaseFilterTypeVignette,
    MIShowCaseFilterTypeNone
};

@interface MIShowCaseFilterViewController : UIViewController

- (instancetype)initWithFilterType:(MIShowCaseFilterType)filterType;

@end
