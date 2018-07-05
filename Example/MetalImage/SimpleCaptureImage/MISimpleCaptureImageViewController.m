//
//  MISimpleCaptureImageViewController.m
//  MetalImage
//
//  Created by zsr on 2018/6/24.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MISimpleCaptureImageViewController.h"
#import <MetalImage/MetalImage.h>
#import <Photos/Photos.h>

@interface MISimpleCaptureImageViewController ()
{
    MIVideoCamera *_camera;
    MIFilter *_defaultFilter;
    
    MIFilter *_processFilter;
    MIFilter *_viewFilter;
    
    MIView *_displayView;
}

@end

@implementation MISimpleCaptureImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SimpleCaptureImage";

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    _displayView = [[MIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [self.view addSubview:_displayView];
    _displayView.backgroundColor = [UIColor colorWithRed:0 green:104.0/255.0 blue:55.0/255.0 alpha:1.0];
    [self.view addSubview:_displayView];
    
#if !TARGET_IPHONE_SIMULATOR
    [self cheackAuthority];
#endif
    
    CGFloat buttonWidth = width / 2;
    CGFloat buttonHeight = 50;
    CGFloat buttonY = height - buttonHeight;
    
    UIButton *shutterOriginalButton = [[UIButton alloc] initWithFrame:CGRectMake(0, buttonY, buttonWidth, buttonHeight)];
    [shutterOriginalButton setTitle:@"拍原图" forState:UIControlStateNormal];
    [shutterOriginalButton addTarget:self action:@selector(shutterOriginal:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shutterOriginalButton];
    
    UIButton *shutterProcessButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth * 1, buttonY, buttonWidth, buttonHeight)];
    [shutterProcessButton setTitle:@"拍效果图" forState:UIControlStateNormal];
    [shutterProcessButton addTarget:self action:@selector(shutterProcess:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shutterProcessButton];
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
    _camera = [[MIVideoCamera alloc] initWithCameraPosition:AVCaptureDevicePositionFront sessionPreset:AVCaptureSessionPresetPhoto];
    _camera.photoCaptureEnabled = YES;
    
    _defaultFilter = [[MIFilter alloc] init];
    _processFilter = [[MIGrayscaleFilter alloc] init];
    
    
    _viewFilter = [[MIFilter alloc] init];
    //    设置在_displayView里面渲染的区域
    NSInteger displayViewWidth = _displayView.contentSize.width;
    NSInteger displayViewHeight = _displayView.contentSize.height;
    _viewFilter.outputFrame = CGRectMake(0,
                                         (int)((displayViewHeight - (displayViewWidth * 4.0/3)) * 0.5),
                                         displayViewWidth,
                                         (int)(displayViewWidth * 4.0/3));
    //处理链
    [_camera addConsumer:_defaultFilter];
    [_defaultFilter addConsumer:_processFilter];
    [_processFilter addConsumer:_viewFilter];
    [_viewFilter addConsumer:_displayView];
    
#if !TARGET_IPHONE_SIMULATOR
    [_camera startRunning];
#endif
}


#pragma mark - UI操作

- (void)shutterOriginal:(UIButton *)button {
    [_camera captureOriginalImageAsynchronouslyWithCompletionHandler:^(UIImage *originalImage, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            [self saveImageToAlbum:originalImage];
        }
    }];
}


- (void)shutterProcess:(UIButton *)button {
    UIImage *processImage = [_processFilter imageFromCurrentFrame];
    [self saveImageToAlbum:processImage];
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
