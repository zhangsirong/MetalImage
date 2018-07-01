//
//  MESimpleVideoFilterViewController.m
//  MetalImage
//
//  Created by zsr on 2018/6/17.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MESimpleVideoFilterViewController.h"
#import <MetalImage/MetalImage.h>
#import <Photos/Photos.h>

@interface MESimpleVideoFilterViewController ()<MIVideoCameraDelegate, MIAudioVideoWriterDelegate>
{
    MIVideoCamera *_camera;
    MIFilter *_defaultFilter;
    MISepiaFilter *_sepiaFilter;
    MIView *_displayView;
    MIAudioVideoWriter *_videoWriter;
    
    MIFilter *_viewFilter;
    MIFilter *_videoWriterFilter;

    NSString *_filePath;
    
    UIButton *_startRecordButton;
    UIButton *_stopRecordButton;
}
@end

@implementation MESimpleVideoFilterViewController

- (void)dealloc {
    [_camera stopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SimpleVideoFilter";

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    _displayView = [[MIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [self.view addSubview:_displayView];
    _displayView.backgroundColor = [UIColor colorWithRed:0 green:104.0/255.0 blue:55.0/255.0 alpha:1.0];
    
    _filePath = [NSTemporaryDirectory() stringByAppendingString:@"test.mp4"];

#if !TARGET_IPHONE_SIMULATOR
    [self cheackAuthority];
#endif

    
    CGFloat buttonWidth = width / 2;
    CGFloat buttonHeight = 50;
    CGFloat buttonY = height - buttonHeight;
    
    _startRecordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, buttonY, buttonWidth, buttonHeight)];
    [_startRecordButton setTitle:@"开始录像" forState:UIControlStateNormal];
    [_startRecordButton addTarget:self action:@selector(startRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startRecordButton];
    
    _stopRecordButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth * 1, buttonY, buttonWidth, buttonHeight)];
    [_stopRecordButton setTitle:@"停止录像" forState:UIControlStateNormal];
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
    _camera = [[MIVideoCamera alloc] initWithCameraPosition:AVCaptureDevicePositionFront sessionPreset:AVCaptureSessionPresetPhoto];
    _camera.delegate = self;

    _defaultFilter = [[MIFilter alloc] init];
    _sepiaFilter = [[MISepiaFilter alloc] init];
    _viewFilter = [[MIFilter alloc] init];//做在view中的位置调整

    //    设置在_displayView里面渲染的区域
    NSInteger displayViewWidth = _displayView.contentSize.width;
    NSInteger displayViewHeight = _displayView.contentSize.height;
    _viewFilter.outputFrame = CGRectMake(0,
                                          (int)((displayViewHeight - (displayViewWidth * 4.0/3)) * 0.5),
                                          displayViewWidth,
                                          (int)(displayViewWidth * 4.0/3));
    
    _videoWriterFilter = [[MIFilter alloc] init];//做在video中的位置调整
    
    //创建videoWriter
    NSDictionary *videoCompressionProps = @{AVVideoAverageBitRateKey : [NSNumber numberWithDouble:2.0*1024.0*1024.0]};
    NSDictionary *writerSetting = @{AVVideoCodecKey : AVVideoCodecH264, AVVideoCompressionPropertiesKey : videoCompressionProps};
    
    _videoWriter = [[MIAudioVideoWriter alloc] initWithOutputURL:[NSURL fileURLWithPath:_filePath]];
    _videoWriter.delegate = self;
    _videoWriter.shouldWriteWithAudio = YES;
    _videoWriter.writingInRealTime = YES;
    _videoWriter.compressionAudioSettings = _camera.recommendedAudioSettings;
    _videoWriter.videoOutputSettings = writerSetting;
    
    
    //处理链
    [_camera addConsumer:_defaultFilter];
    [_defaultFilter addConsumer:_sepiaFilter];
    [_sepiaFilter addConsumer:_viewFilter];
    [_sepiaFilter addConsumer:_videoWriter];
    
    [_viewFilter addConsumer:_displayView];
    [_videoWriterFilter addConsumer:_videoWriter];
    
#if !TARGET_IPHONE_SIMULATOR
    [_camera startRunning];
#endif
}


#pragma mark - UI操作

- (void)startRecord:(UIButton *)button {
    [[NSFileManager defaultManager] removeItemAtPath:_filePath error:nil];
    _videoWriter.enabled = YES;
    
    [_startRecordButton setTitle:@"录像中..." forState:UIControlStateNormal];
    _startRecordButton.enabled = NO;
    _stopRecordButton.enabled = YES;
    _stopRecordButton.alpha = 1.0;
}

- (void)stopRecord:(UIButton *)button {
    [_videoWriter finishWriting];
    
    [_startRecordButton setTitle:@"开始录像" forState:UIControlStateNormal];
    _startRecordButton.enabled = YES;
    _stopRecordButton.enabled = NO;
    _stopRecordButton.alpha = 0.5;
}


#pragma mark - MIAudioVideoWriterDelegate

- (void)audioVideoWriter:(MIAudioVideoWriter *)audioVideoWriter isWritingAtTime:(CMTime)frameTime {
    NSLog(@"%.2f",CMTimeGetSeconds(frameTime));
}

- (void)audioVideoWriterDidfinishWriting:(MIAudioVideoWriter *)audioVideoWriter {
    _videoWriter.enabled = NO;
    NSURL *fileURL = [NSURL fileURLWithPath:_filePath];
    //保存到相册
    [PHPhotoLibrary requestAuthorization:^( PHAuthorizationStatus status ) {
        if ( status == PHAuthorizationStatusAuthorized ) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{

                PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
                options.shouldMoveFile = YES;
                PHAssetCreationRequest *creationRequest = [PHAssetCreationRequest creationRequestForAsset];
                [creationRequest addResourceWithType:PHAssetResourceTypeVideo fileURL:fileURL options:options];
            } completionHandler:^( BOOL success, NSError *error ) {
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
                    NSLog( @"Could not save Video to photo library: %@", error );
                }
            }];
        }
    }];
}


#pragma mark - MIVideoCameraDelegate

- (void)videoCamera:(MIVideoCamera *)videoCamera didReceiveAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    if (_videoWriter.isEnabled) {
        CFRetain(sampleBuffer);
        [_videoWriter writeWithAudioSampleBuffer:sampleBuffer];
        CFRelease(sampleBuffer);
    }
}

- (void)videoCaptor:(MIVideoCaptor *)videoCaptor willOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
}



@end
