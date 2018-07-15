//
//  MISimpleImageFilterViewController.m
//  MetalImage
//
//  Created by zsr on 2018/6/24.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MISimpleImageFilterViewController.h"
#import <MetalImage/MetalImage.h>
#import <Photos/Photos.h>

@interface MISimpleImageFilterViewController ()
{
    UIImage *_sourceImage;
    UIImageView *_imageView;
    UISlider *_slider;
    MIImage *_miImage;
    
    MIFilter *_filter;
    UIButton *_saveButton;
}
@end

@implementation MISimpleImageFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:104.0/255.0 blue:55.0/255.0 alpha:1.0];
    self.title = @"Simple Image";

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
    
    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(width - 100, 100, 100, 100)];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
}

- (void)sliderDidChange:(UISlider *)slider {
    ((MISwirlFilter *)_filter).angle = slider.value;
    [_miImage processingImage];
    UIImage *processImage = [_filter imageFromCurrentFrame];
    _imageView.image = processImage;
}

- (void)save:(UIButton *)button {
    [self saveImageToAlbum:_imageView.image];
}

- (void)saveImageToAlbum:(UIImage *)image {
    //保存到相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        assetRequest.creationDate = [NSDate date];
    } completionHandler:^(BOOL success, NSError *error) {
        if (success ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NULL message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertVC addAction:action];
                [self presentViewController:alertVC animated:YES completion:nil];
            });
            
        } else {
            NSLog( @"Could not save Video to photo library: %@", error );
        }
    }];
}

@end
