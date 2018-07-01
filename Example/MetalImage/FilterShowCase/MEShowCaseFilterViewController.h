//
//  MEShowCaseFilterViewController.h
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MEShowCaseFilterType) {
    MEShowCaseFilterTypeMirror = 0,
    MEShowCaseFilterTypeLookupTable,
    MEShowCaseFilterTypePixellation,
    MEShowCaseFilterTypeHalftone,
    MEShowCaseFilterTypeCrosshatch,
    MEShowCaseFilterTypeEmboss,
    MEShowCaseFilterTypePerlinNoise,
    MEShowCaseFilterTypePixellatePosition,
    MEShowCaseFilterTypePolarPixellate,
    MEShowCaseFilterTypePolkaDot,
    MEShowCaseFilterTypeSketch,
    MEShowCaseFilterTypeThresholdSketch,
    MEShowCaseFilterTypeToon,
    MEShowCaseFilterTypeSmoothToon,
    MEShowCaseFilterTypeCGAColorspace,
    MEShowCaseFilterTypePosterize,
    MEShowCaseFilterTypeSwirl,
    MEShowCaseFilterTypeBulgeDistortion,
    MEShowCaseFilterTypePinchDistortion,
    MEShowCaseFilterTypeStretchDistortion,
    MEShowCaseFilterTypeSphereRefraction,
    MEShowCaseFilterTypeGlassSphere,
    MEShowCaseFilterTypeKuwahara,
    MEShowCaseFilterTypeKuwaharaRadius3,
    MEShowCaseFilterTypeVignette,
    MEShowCaseFilterTypeNone
};

@interface MEShowCaseFilterViewController : UIViewController

- (instancetype)initWithFilterType:(MEShowCaseFilterType)filterType;

@end
