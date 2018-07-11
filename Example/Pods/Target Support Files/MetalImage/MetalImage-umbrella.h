#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MIConsumer.h"
#import "MIContext.h"
#import "MIProducer.h"
#import "MITexture.h"
#import "MIAudioVideoWriter.h"
#import "MIGifWriter.h"
#import "MIView.h"
#import "MI3x3ConvolutionFilter.h"
#import "MI3x3TextureSamplingFilter.h"
#import "MIFilterGroup.h"
#import "MITwoInputFilter.h"
#import "MITwoPassFilter.h"
#import "MITwoPassTextureSamplingFilter.h"
#import "MIBlendFilter.h"
#import "MIAverageColorFilter.h"
#import "MIBrightnessFilter.h"
#import "MIColorInvertFilter.h"
#import "MIColorMatrixFilter.h"
#import "MIContrastFilter.h"
#import "MIExposureFilter.h"
#import "MIFalseColorFilter.h"
#import "MIGammaFilter.h"
#import "MIGrayscaleFilter.h"
#import "MIHazeFilter.h"
#import "MIHSBFilter.h"
#import "MIHueFilter.h"
#import "MILevelsFilter.h"
#import "MILookupTableFilter.h"
#import "MILuminanceThresholdFilter.h"
#import "MIMonochromeFilter.h"
#import "MIRGBFilter.h"
#import "MISaturationFilter.h"
#import "MISepiaFilter.h"
#import "MISolarizeFilter.h"
#import "MIBulgeDistortionFilter.h"
#import "MICGAColorspaceFilter.h"
#import "MICrosshatchFilter.h"
#import "MIEmbossFilter.h"
#import "MIGlassSphereFilter.h"
#import "MIHalftoneFilter.h"
#import "MIKuwaharaFilter.h"
#import "MIKuwaharaRadius3Filter.h"
#import "MIMirrorFilter.h"
#import "MIPerlinNoiseFilter.h"
#import "MIPinchDistortionFilter.h"
#import "MIPixellatePositionFilter.h"
#import "MIPixellationFilter.h"
#import "MIPolarPixellateFilter.h"
#import "MIPolkaDotFilter.h"
#import "MIPosterizeFilter.h"
#import "MISketchFilter.h"
#import "MISmoothToonFilter.h"
#import "MISphereRefractionFilter.h"
#import "MIStretchDistortionFilter.h"
#import "MISwirlFilter.h"
#import "MIThresholdSketchFilter.h"
#import "MIToonFilter.h"
#import "MIVignetteFilter.h"
#import "MIBoxBlurFilter.h"
#import "MICropFilter.h"
#import "MIGaussianBlurFilter.h"
#import "MISobelEdgeDetectionFilter.h"
#import "MIThresholdEdgeDetectionFilter.h"
#import "MIFilter.h"
#import "MetalImage.h"
#import "MIImage.h"
#import "MIUIElement.h"
#import "MIVideo.h"
#import "MIVideoCamera.h"
#import "MIVideoCaptor.h"

FOUNDATION_EXPORT double MetalImageVersionNumber;
FOUNDATION_EXPORT const unsigned char MetalImageVersionString[];

