//
//  MISimpleGifFilterViewController.m
//  MetalImage
//
//  Created by zsr on 2018/6/24.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MISimpleGifFilterViewController.h"
#import <MetalImage/MetalImage.h>
#import <Photos/Photos.h>

@interface MISimpleGifFilterViewController () <MIGIFWriterDelegate>
{
    MIVideoCamera *_camera;
    MIFilter *_defaultFilter;
    MIFilter *_processFilter;
    MIView *_displayView;
    MIGifWriter *_gifWriter;
    
    MIFilter *_viewFilter;
    MIFilter *_gifWriterFilter;
    
    NSString *_filePath;
    
    UIButton *_startRecordButton;
    UIButton *_stopRecordButton;
}
@end

@implementation MISimpleGifFilterViewController
- (void)dealloc {
    [_camera stopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Simple Gif";
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    _displayView = [[MIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [self.view addSubview:_displayView];
    _displayView.backgroundColor = [UIColor colorWithRed:0 green:104.0/255.0 blue:55.0/255.0 alpha:1.0];
    
    _filePath = [NSTemporaryDirectory() stringByAppendingString:@"MetalImage.gif"];
    
#if !TARGET_IPHONE_SIMULATOR
    [self cheackAuthority];
#endif
    
    
    CGFloat buttonWidth = width / 2;
    CGFloat buttonHeight = 50;
    CGFloat buttonY = height - buttonHeight;
    
    _startRecordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, buttonY, buttonWidth, buttonHeight)];
    [_startRecordButton setTitle:@"开始录GIF" forState:UIControlStateNormal];
    [_startRecordButton addTarget:self action:@selector(startRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startRecordButton];
    
    _stopRecordButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth * 1, buttonY, buttonWidth, buttonHeight)];
    [_stopRecordButton setTitle:@"停止录GIF" forState:UIControlStateNormal];
    [_stopRecordButton addTarget:self action:@selector(stopRecord:) forControlEvents:UIControlEventTouchUpInside];
    _stopRecordButton.enabled = NO;
    _stopRecordButton.alpha = 0.5;
    [self.view addSubview:_stopRecordButton];
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
    
    NSInteger displayViewWidth = _displayView.contentSize.width;
    NSInteger displayViewHeight = _displayView.contentSize.height;
    
    _camera = [[MIVideoCamera alloc] initWithCameraPosition:AVCaptureDevicePositionFront sessionPreset:AVCaptureSessionPresetPhoto];
    _camera.outputFrame = CGRectMake(0, 0, displayViewWidth, ceil(displayViewWidth * 4.0 /3.0));
        
    _defaultFilter = [[MIFilter alloc] init];
    _processFilter = [[MIGrayscaleFilter alloc] init];
    
//    设置在_displayView里面渲染的区域
    _viewFilter = [[MIFilter alloc] init];//做在view中的位置调整
    _viewFilter.outputFrame = CGRectMake(0,
                                         (int)((displayViewHeight - (displayViewWidth * 4.0/3)) * 0.5),
                                         displayViewWidth,
                                         (int)(displayViewWidth * 4.0/3));
    
    _gifWriterFilter = [[MIFilter alloc] init];//做在gif中的位置调整
    _gifWriterFilter.outputFrame = CGRectMake(0, (240 - 320) / 2, 240, 240 / 3 * 4);
    
    _gifWriter = [[MIGifWriter alloc] initWithContentSize:CGSizeMake(240, 240) outputURL:[NSURL fileURLWithPath:_filePath] maxFrame:27];
    _gifWriter.delegate = self;
    
    
    //处理链
    [_camera addConsumer:_defaultFilter];
    [_defaultFilter addConsumer:_processFilter];
    [_processFilter addConsumer:_viewFilter];
    [_processFilter addConsumer:_gifWriterFilter];
    
    [_viewFilter addConsumer:_displayView];
    [_gifWriterFilter addConsumer:_gifWriter];
    
#if !TARGET_IPHONE_SIMULATOR
    [_camera startRunning];
#endif
}


#pragma mark - UI操作

- (void)startRecord:(UIButton *)button {
    [[NSFileManager defaultManager] removeItemAtPath:_filePath error:nil];
    _gifWriter.orientation = _camera.orientation;
    _gifWriter.enabled = YES;
    
    [_startRecordButton setTitle:@"录GIF中..." forState:UIControlStateNormal];
    _startRecordButton.enabled = NO;
    _stopRecordButton.enabled = YES;
    _stopRecordButton.alpha = 1.0;
}

- (void)stopRecord:(UIButton *)button {
    [_gifWriter finishWriting];
}

#pragma mark - MIGIFWriterDelegate

- (void)gifWriter:(MIGifWriter *)gifWriter didAddImageWithIndex:(NSInteger)index {
    NSLog(@"%ld",(long)index);
}

- (void)gifWriterDidFinishWriting:(MIGifWriter *)gifWriter {
    NSLog(@"finishGIF");
    dispatch_async(dispatch_get_main_queue(), ^{
        [_startRecordButton setTitle:@"开始录GIF" forState:UIControlStateNormal];
        _startRecordButton.enabled = YES;
        _stopRecordButton.enabled = NO;
        _stopRecordButton.alpha = 0.5;
    });
    
    [self saveGIFFileToAlbumWithFileURL:gifWriter.outputURL];
}

//保存GIF文件到相册
- (void)saveGIFFileToAlbumWithFileURL:(NSURL *)fileURL {
    if (![fileURL.absoluteString hasSuffix:@".gif"]) {
        return;
    }
    
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
        options.shouldMoveFile = YES;
        [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:data options:options];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NULL message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertVC addAction:action];
                [self presentViewController:alertVC animated:YES completion:nil];
            });
        } else {
            NSLog(@"保存失败");
        }
    }];
}

@end
