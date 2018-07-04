//
//  MESimpleVideoFileFilterViewController.m
//  MetalImage
//
//  Created by zsr on 2018/6/24.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MESimpleVideoFileFilterViewController.h"
#import <MetalImage/MetalImage.h>
#import <Photos/Photos.h>

@interface MESimpleVideoFileFilterViewController () <MIVideoDelegate, MIAudioVideoWriterDelegate>
{
    MIVideo *_sourceVideo;
    MIFilter *_viewFilter;
    MIView *_displayView;
    MIFilter *_processFilter;
    MIAudioVideoWriter *_videoWriter;
    UISlider *_slider;
}

@end


@implementation MESimpleVideoFileFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SimpleVideoFileFilter";

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"];
    
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    _sourceVideo = [[MIVideo alloc] initWithURL:fileURL];
    _sourceVideo.delegate = self;
    _sourceVideo.playAtActualSpeed = NO;
    _displayView = [[MIView alloc] initWithFrame:self.view.bounds];
    
    _displayView.backgroundColor = [UIColor yellowColor];
    
    _processFilter = [[MIPixellationFilter alloc] init];
    _viewFilter = [[MIFilter alloc] init];
    
    CGRect outputFrame = CGRectZero;
    outputFrame.size.width = _displayView.contentSize.width;
    outputFrame.size.height = outputFrame.size.width * _sourceVideo.size.height / _sourceVideo.size.width;
    outputFrame.origin.x = 0;
    outputFrame.origin.y = (_displayView.contentSize.height - outputFrame.size.height) * 0.5;

    _viewFilter.outputFrame = outputFrame;
    
    NSString *processFilePath = [NSTemporaryDirectory() stringByAppendingString:@"test.mp4"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:processFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:processFilePath error:nil];
    }
    
    NSDictionary *videoCompressionProps = @{AVVideoAverageBitRateKey : [NSNumber numberWithDouble:2.0*1024.0*1024.0]};
    NSDictionary *writerSetting = @{AVVideoCodecKey : AVVideoCodecH264, AVVideoCompressionPropertiesKey : videoCompressionProps};
    
    _videoWriter = [[MIAudioVideoWriter alloc] initWithOutputURL:[NSURL fileURLWithPath:processFilePath]];
    _videoWriter.delegate = self;
    _videoWriter.shouldWriteWithAudio = YES;
    _videoWriter.writingInRealTime = YES;
    _videoWriter.videoOutputSettings = writerSetting;
    
    [_sourceVideo addConsumer:_processFilter];
    [_processFilter addConsumer:_videoWriter];
    [_processFilter addConsumer:_viewFilter];

    [_viewFilter addConsumer:_displayView];

    [self.view addSubview:_displayView];
    
    [_sourceVideo play];
    _videoWriter.enabled = YES;

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(50, height - 50 , width - 100, 50)];
    [_slider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];
    _slider.maximumValue = 1.0/5.0;
    _slider.minimumValue = 1.0/640;
    _slider.value = 1.0/50.0;
    [self.view addSubview:_slider];
}

- (void)sliderDidChange:(UISlider *)slider {
    ((MIPixellationFilter *)_processFilter).fractionalWidthOfAPixel = slider.value;
}



#pragma mark - MIVideoDelegate

- (void)video:(MIVideo *)video willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    NSLog(@"progress : %.2f",video.progress);
}

- (void)videoDidEnd:(MIVideo *)video {
    [_videoWriter finishWriting];
    NSLog(@"%s", __FUNCTION__);
}


#pragma mark - MIAudioVideoWriterDelegate

- (void)audioVideoWriterRequestNextAudioSampleBuffer:(MIAudioVideoWriter *)audioVideoWriter {
    CMSampleBufferRef audioBuffer = [_sourceVideo copyNextAudioSampleBuffer];
    [audioVideoWriter writeWithAudioSampleBuffer:audioBuffer];
    if(audioBuffer != NULL){
        CFRelease(audioBuffer);
    }
}

- (void)audioVideoWriterDidfinishWriting:(MIAudioVideoWriter *)audioVideoWriter {
    _videoWriter.enabled = NO;
    NSString *processFilePath = [NSTemporaryDirectory() stringByAppendingString:@"test.mp4"];

    NSURL *fileURL = [NSURL fileURLWithPath:processFilePath];
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

- (void)audioVideoWriter:(MIAudioVideoWriter *)audioVideoWriter isWritingAtTime:(CMTime)frameTime {
    NSLog(@"time:%.2f",CMTimeGetSeconds(frameTime));

}






@end
