//
//  MetalImage.h
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MetalImage/MIContext.h>
#import <MetalImage/MIConsumer.h>
#import <MetalImage/MIProducer.h>
#import <MetalImage/MITexture.h>
#import <MetalImage/MIVideoCaptor.h>
#import <MetalImage/MIVideoCamera.h>
#import <MetalImage/MIImage.h>
#import <MetalImage/MIUIElement.h>
#import <MetalImage/MIContext.h>
#import <MetalImage/MIView.h>
#import <MetalImage/MIGifWriter.h>
#import <MetalImage/MIAudioVideoWriter.h>
#import <MetalImage/MIFilter.h>
#import <MetalImage/MIVideo.h>

//Filter
#import <MetalImage/MIMirrorFilter.h>
#import <MetalImage/MILookupTableFilter.h>

#import <MetalImage/MIEmbossFilter.h>
#import <MetalImage/MITwoInputFilter.h>
#import <MetalImage/MIPerlinNoiseFilter.h>
#import <MetalImage/MIPixellationFilter.h>
#import <MetalImage/MIPixellatePositionFilter.h>
#import <MetalImage/MIPolkaDotFilter.h>
#import <MetalImage/MIHalftoneFilter.h>
#import <MetalImage/MIPolarPixellateFilter.h>
#import <MetalImage/MICrosshatchFilter.h>
#import <MetalImage/MITwoPassFilter.h>
#import <MetalImage/MIGrayscaleFilter.h>
#import <MetalImage/MISobelEdgeDetectionFilter.h>
#import <MetalImage/MISketchFilter.h>
#import <MetalImage/MIThresholdEdgeDetectionFilter.h>
#import <MetalImage/MIThresholdSketchFilter.h>
#import <MetalImage/MIToonFilter.h>
#import <MetalImage/MIGaussianBlurFilter.h>
#import <MetalImage/MIBoxBlurFilter.h>
#import <MetalImage/MISmoothToonFilter.h>
#import <MetalImage/MICGAColorspaceFilter.h>
#import <MetalImage/MIPosterizeFilter.h>
#import <MetalImage/MISwirlFilter.h>
#import <MetalImage/MIBulgeDistortionFilter.h>
#import <MetalImage/MIPinchDistortionFilter.h>
#import <MetalImage/MIStretchDistortionFilter.h>
#import <MetalImage/MISphereRefractionFilter.h>
#import <MetalImage/MIGlassSphereFilter.h>
#import <MetalImage/MIKuwaharaFilter.h>
#import <MetalImage/MIKuwaharaRadius3Filter.h>
#import <MetalImage/MIVignetteFilter.h>

#import <MetalImage/MIBrightnessFilter.h>
#import <MetalImage/MIExposureFilter.h>
#import <MetalImage/MIContrastFilter.h>
#import <MetalImage/MISaturationFilter.h>
#import <MetalImage/MIGammaFilter.h>
#import <MetalImage/MIColorMatrixFilter.h>
#import <MetalImage/MIRGBFilter.h>
#import <MetalImage/MIHueFilter.h>
#import <MetalImage/MIMonochromeFilter.h>
#import <MetalImage/MIColorInvertFilter.h>
#import <MetalImage/MISepiaFilter.h>
#import <MetalImage/MIFalseColorFilter.h>
#import <MetalImage/MIHazeFilter.h>
#import <MetalImage/MIHSBFilter.h>
#import <MetalImage/MILuminanceThresholdFilter.h>
#import <MetalImage/MILevelsFilter.h>
#import <MetalImage/MISolarizeFilter.h>
#import <MetalImage/MIAverageColorFilter.h>
#import <MetalImage/MICropFilter.h>
#import <MetalImage/MIBlendFilter.h>
