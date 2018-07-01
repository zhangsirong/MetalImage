//
//  MESimpleImageFilterViewController.m
//  MetalImage
//
//  Created by zsr on 2018/6/24.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MESimpleImageFilterViewController.h"
#import <MetalImage/MetalImage.h>

@interface MESimpleImageFilterViewController ()
{
    UIImage *_sourceImage;
    UIImageView *_imageView;
    UISlider *_slider;
    MIImage *_miImage;
    
    MIFilter *_filter;
}
@end

@implementation MESimpleImageFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:104.0/255.0 blue:55.0/255.0 alpha:1.0];

    self.title = @"SimpleImageFilter";

    _sourceImage = [UIImage imageNamed:@"lena"];
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:_imageView];
    
    _imageView.image = _sourceImage;
    _miImage = [[MIImage alloc] initWithUIImage:_sourceImage];
    _filter = [[MISwirlFilter alloc] init];

    [_miImage addConsumer:_filter];
    [_miImage processingImage];
    
    UIImage *processImage = [_filter imageFromCurrentFrame];
    _imageView.image = processImage;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(50, height - 50 , width - 100, 50)];
    [_slider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];
    _slider.maximumValue = 1.0;
    _slider.minimumValue = 0.0;
    _slider.value = 1.0;
    [self.view addSubview:_slider];
}

- (void)sliderDidChange:(UISlider *)slider {
    ((MISwirlFilter *)_filter).angle = slider.value;
    [_miImage processingImage];
    UIImage *processImage = [_filter imageFromCurrentFrame];
    _imageView.image = processImage;
}

@end
