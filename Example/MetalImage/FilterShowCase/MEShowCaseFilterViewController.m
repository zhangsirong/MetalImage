//
//  MEShowCaseFilterViewController.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MEShowCaseFilterViewController.h"
#import <MetalImage/MetalImage.h>

@interface MEShowCaseFilterViewController ()
{
    MEShowCaseFilterType _filterType;
    MIVideoCaptor *_camera;
    MIFilter *_defaultFilter;
    MIProducer<MIConsumer> *_filter;
    MIView *_displayView;
    UISlider *_slider;
}
@end

@implementation MEShowCaseFilterViewController

- (instancetype)initWithFilterType:(MEShowCaseFilterType)filterType {
    if (self = [super init]) {
         _filterType = filterType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    _displayView = [[MIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [self.view addSubview:_displayView];
    _displayView.backgroundColor = [UIColor colorWithRed:0 green:104.0/255.0 blue:55.0/255.0 alpha:1.0];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(50, height - 50 , width - 100, 50)];
    [_slider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];
    _slider.maximumValue = 1.0;
    _slider.minimumValue = 0.0;
    _slider.value = 1.0;
    [self.view addSubview:_slider];
    
#if !TARGET_IPHONE_SIMULATOR
    [self cheackAuthority];
#endif

}


#pragma mark - 初始化镜头

- (void)cheackAuthority {
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (videoStatus == AVAuthorizationStatusDenied) {
        NSLog(@"未授权");
    } else if (videoStatus == AVAuthorizationStatusAuthorized) {
        [self startInitCameraConfig];
    } else if (videoStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {//镜头点击了允许授权
                    [self startInitCameraConfig];
                } else {//镜头点击了拒绝访问
                    NSLog(@"未授权");
                }
            });
        }];
    }
}

- (void)startInitCameraConfig {
    _camera = [[MIVideoCaptor alloc] initWithCameraPosition:AVCaptureDevicePositionFront sessionPreset:AVCaptureSessionPresetPhoto];
    
    _defaultFilter = [[MIFilter alloc] init];
    
    [self setupFilter];
    
//    设置在_displayView里面渲染的区域
    NSInteger displayViewWidth = _displayView.contentSize.width;
    NSInteger displayViewHeight = _displayView.contentSize.height;
    _filter.outputFrame = CGRectMake(0,
                                     (int)((displayViewHeight - (displayViewWidth * 4.0/3)) * 0.5),
                                     displayViewWidth,
                                     (int)(displayViewWidth * 4.0/3));
    
    [_camera addConsumer:_defaultFilter];
    [_defaultFilter addConsumer:_filter];
    [_filter addConsumer:_displayView];
    
#if !TARGET_IPHONE_SIMULATOR
    [_camera startRunning];
#endif
}


#pragma mark - filter

- (void)setupFilter {
    switch (_filterType) {
        case MEShowCaseFilterTypeMirror: {
            self.title = @"Mirror";
            _slider.hidden = YES;
            _filter = [[MIMirrorFilter alloc] init];
        }
            break;
            
        case MEShowCaseFilterTypeLookupTable: {
            self.title = @"LookupTable";
            _slider.hidden = NO;
            _slider.minimumValue = 0.0;
            _slider.maximumValue = 1.0;
            _slider.value = 1.0;
            _filter = [[MILookupTableFilter alloc] init];
            UIImage *image = [UIImage imageNamed:@"lookup1"];
            [(MILookupTableFilter *)_filter updateLookupTableImage:image];
        }
            break;
        case MEShowCaseFilterTypePixellation: {
            self.title = @"Pixellation";
            _slider.hidden = NO;
            _slider.minimumValue = 1/300.0;
            _slider.maximumValue = 1/5.0;
            _slider.value = 1/20.0;
            _filter = [[MIPixellationFilter alloc] init];
        }
            break;
        case MEShowCaseFilterTypeHalftone: {
            self.title = @"Halftone";
            _slider.hidden = NO;
            _slider.minimumValue = 1/300.0;
            _slider.maximumValue = 1/5.0;
            _slider.value = 1/20.0;
            _filter = [[MIHalftoneFilter alloc] init];
        }
            break;
        case MEShowCaseFilterTypeCrosshatch: {
            self.title = @"Crosshatch";
            _slider.hidden = NO;
            _slider.minimumValue = 0.01;
            _slider.maximumValue = 0.06;
            _slider.value = 0.03;
            _filter = [[MICrosshatchFilter alloc] init];
        }
            break;
        case MEShowCaseFilterTypeEmboss: {
            self.title = @"Emboss";
            _slider.hidden = NO;
            _slider.minimumValue = 0;
            _slider.maximumValue = 4;
            _slider.value = 1;
            _filter = [[MIEmbossFilter alloc] init];
        }
            break;
        case MEShowCaseFilterTypePerlinNoise: {
            self.title = @"PerlinNoise";
            _slider.hidden = NO;
            _slider.minimumValue = 0;
            _slider.maximumValue = 10;
            _slider.value = 8.0;
            _filter = [[MIPerlinNoiseFilter alloc] init];
        }
            break;
        case MEShowCaseFilterTypePixellatePosition: {
            self.title = @"PixellatePosition";
            _slider.hidden = NO;
            _slider.minimumValue = 0;
            _slider.maximumValue = 0.5;
            _slider.value = 0.25;
            _filter = [[MIPixellatePositionFilter alloc] init];
        }
            break;
            
        case MEShowCaseFilterTypePolarPixellate: {
            self.title = @"PolarPixellate";
            _slider.hidden = NO;
            _slider.minimumValue = -0.1;
            _slider.maximumValue = 0.1;
            _slider.value = 0.05;
            _filter = [[MIPolarPixellateFilter alloc] init];
        }
            break;
            
        case MEShowCaseFilterTypePolkaDot: {
            self.title = @"PolkaDot";
            _slider.hidden = NO;
            _slider.minimumValue = 0.0;
            _slider.maximumValue = 0.3;
            _slider.value = 0.05;
            _filter = [[MIPolkaDotFilter alloc] init];
        }
            break;
        case MEShowCaseFilterTypeSketch: {
            self.title = @"Sketch";
            _slider.hidden = NO;
            _slider.minimumValue = 0.0;
            _slider.maximumValue = 1.0;
            _slider.value = 0.25;
            _filter = [[MISketchFilter alloc] init];
        }
            break;
        case MEShowCaseFilterTypeThresholdSketch: {
            self.title = @"ThresholdSketch";
            _slider.hidden = NO;
            _slider.minimumValue = 0.0;
            _slider.maximumValue = 1.0;
            _slider.value = 0.25;
            _filter = [[MIThresholdSketchFilter alloc] init];
        }
            break;
        case MEShowCaseFilterTypeToon: {
            self.title = @"Toon";
            _slider.hidden = YES;
            _filter = [[MIToonFilter alloc] init];
        }
            break;
        case MEShowCaseFilterTypeSmoothToon: {
            self.title = @"SmoothToon";
            _slider.hidden = NO;
            _slider.minimumValue = 1.0;
            _slider.maximumValue = 6.0;
            _slider.value = 1.0;
            _filter = [[MISmoothToonFilter alloc] init];
        }
            break;
        case MEShowCaseFilterTypeCGAColorspace: {
            self.title = @"CGAColorspace";
            _slider.hidden = YES;
            _filter = [[MICGAColorspaceFilter alloc] init];
        }
            break;
        case MEShowCaseFilterTypePosterize: {
            self.title = @"Posterize";
            _slider.hidden = NO;
            _slider.minimumValue = 1.0;
            _slider.maximumValue = 20.0;
            _slider.value = 10.0;
            _filter = [[MIPosterizeFilter alloc] init];
        }
            break;
        case MEShowCaseFilterTypeSwirl: {
            self.title = @"Swirl";
            _slider.hidden = NO;
            _slider.minimumValue = 0.0;
            _slider.maximumValue = 2.0;
            _slider.value = 1.0;
            _filter = [[MISwirlFilter alloc] init];
        }
            break;
        case MEShowCaseFilterTypeBulgeDistortion: {
            self.title = @"BulgeDistortion";
            _slider.hidden = NO;
            _slider.minimumValue = -1.0;
            _slider.maximumValue = 1.0;
            _slider.value = 0.5;
            _filter = [[MIBulgeDistortionFilter alloc] init];
        }
            break;
        case MEShowCaseFilterTypePinchDistortion: {
            self.title = @"PinchDistortion";
            _slider.hidden = NO;
            _slider.minimumValue = -2.0;
            _slider.maximumValue = 2.0;
            _slider.value = 0.5;
            _filter = [[MIPinchDistortionFilter alloc] init];
        }
            break;
        case MEShowCaseFilterTypeStretchDistortion: {
            self.title = @"StretchDistortion";
            _slider.hidden = NO;
            _slider.minimumValue = 0.0;
            _slider.maximumValue = 1.0;
            _slider.value = 0.5;
            _filter = [[MIStretchDistortionFilter alloc] init];
        }
            break;
        case MEShowCaseFilterTypeSphereRefraction: {
            self.title = @"SphereRefraction";
            _slider.hidden = NO;
            _slider.minimumValue = 0.0;
            _slider.maximumValue = 1.0;
            _slider.value = 0.25;
            _filter = [[MISphereRefractionFilter alloc] init];
        }
            break;
        case MEShowCaseFilterTypeGlassSphere: {
            self.title = @"GlassSphere";
            _slider.hidden = NO;
            _slider.minimumValue = 0.0;
            _slider.maximumValue = 1.0;
            _slider.value = 0.25;
            _filter = [[MIGlassSphereFilter alloc] init];
        }
            break;
        case MEShowCaseFilterTypeKuwahara: {
            self.title = @"Kuwahara";
            _slider.hidden = NO;
            _slider.minimumValue = 3.0;
            _slider.maximumValue = 8.0;
            _slider.value = 3.0;
            _filter = [[MIKuwaharaFilter alloc] init];
        }
            break;
        case MEShowCaseFilterTypeKuwaharaRadius3: {
            self.title = @"KuwaharaRadius3";
            _slider.hidden = YES;
            _filter = [[MIKuwaharaRadius3Filter alloc] init];
        }
            break;
        case MEShowCaseFilterTypeVignette: {
            self.title = @"Vignette";
            _slider.hidden = NO;
            _slider.minimumValue = 0.5;
            _slider.maximumValue = 0.9;
            _slider.value = 0.75;
            _filter = [[MIVignetteFilter alloc] init];
        }
            break;
            
        default: {
            self.title = @"None";
            _slider.hidden = YES;
            _filter = [[MIFilter alloc] init];
        }
            break;
    }
}


#pragma mark - 拉杆

- (void)sliderDidChange:(UISlider *)slider {
    float value = slider.value;
    NSLog(@"value = %.5f", value);
    
    switch (_filterType) {
        case MEShowCaseFilterTypeMirror:
            break;
            
        case MEShowCaseFilterTypeLookupTable:
            ((MILookupTableFilter *)_filter).intensity = value;
            break;
            
        case MEShowCaseFilterTypePixellation:
            ((MIPixellationFilter *)_filter).fractionalWidthOfAPixel = value;
            break;
            
        case MEShowCaseFilterTypeHalftone:
            ((MIHalftoneFilter *)_filter).fractionalWidthOfAPixel = value;
            break;
            
        case MEShowCaseFilterTypeCrosshatch:
            ((MICrosshatchFilter *)_filter).crossHatchSpacing = value;
            break;
            
        case MEShowCaseFilterTypeEmboss:
            ((MIEmbossFilter *)_filter).intensity = value;
            break;
            
        case MEShowCaseFilterTypePerlinNoise:
            ((MIPerlinNoiseFilter *)_filter).scale = value;
            break;
            
        case MEShowCaseFilterTypePixellatePosition:
            ((MIPixellatePositionFilter *)_filter).radius = value;
            break;
            
        case MEShowCaseFilterTypePolarPixellate:
            ((MIPolarPixellateFilter *)_filter).pixelSize = CGSizeMake(value, value);
            break;
            
        case MEShowCaseFilterTypePolkaDot:
            ((MIPolkaDotFilter *)_filter).fractionalWidthOfAPixel = value;
            break;
            
        case MEShowCaseFilterTypeSketch:
            ((MISketchFilter *)_filter).edgeStrength = value;
            break;
            
        case MEShowCaseFilterTypeThresholdSketch:
            ((MIThresholdSketchFilter *)_filter).edgeStrength = value;
            break;
            
        case MEShowCaseFilterTypeSmoothToon:
            ((MISmoothToonFilter *)_filter).blurRadiusInPixels = value;
            break;
            
        case MEShowCaseFilterTypePosterize:
            ((MIPosterizeFilter *)_filter).colorLevels = value;
            break;
            
        case MEShowCaseFilterTypeSwirl:
            ((MISwirlFilter *)_filter).angle = value;
            break;
            
        case MEShowCaseFilterTypeBulgeDistortion:
            ((MIBulgeDistortionFilter *)_filter).scale = value;
            break;
            
        case MEShowCaseFilterTypePinchDistortion:
            ((MIPinchDistortionFilter *)_filter).scale = value;
            break;
            
        case MEShowCaseFilterTypeStretchDistortion:
            ((MIStretchDistortionFilter *)_filter).center = CGPointMake(value, value);
            break;
            
        case MEShowCaseFilterTypeSphereRefraction:
            ((MISphereRefractionFilter *)_filter).radius = value;
            break;
            
        case MEShowCaseFilterTypeGlassSphere:
            ((MIGlassSphereFilter *)_filter).radius = value;
            break;
            
        case MEShowCaseFilterTypeKuwahara:
            ((MIKuwaharaFilter *)_filter).radius = value;
            break;

        case MEShowCaseFilterTypeVignette:
            ((MIVignetteFilter *)_filter).vignetteEnd = value;
            break;
            
        default:
            break;
    }

}


@end
