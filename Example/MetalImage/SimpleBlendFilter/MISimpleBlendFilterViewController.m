//
//  MISimpleBlendFilterViewController.m
//  MetalImage
//
//  Created by zsr on 2018/07/10.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MISimpleBlendFilterViewController.h"
#import <MetalImage/MetalImage.h>

@interface MISimpleBlendFilterViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UISlider *_slider;
    
    MIImage *_frontImage;
    MIImage *_backImage;
    
    MIBlendFilter *_blendFilter;
    MIView *_displayView;
    
    UITableView *_tableView;
    NSArray *_blendModeArray;
}
@end

@implementation MISimpleBlendFilterViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Simple Blend";
    _frontImage = [[MIImage alloc] initWithUIImage:[UIImage imageNamed:@"a1.jpg"]];
    _backImage = [[MIImage alloc] initWithUIImage:[UIImage imageNamed:@"b1.jpg"]];
    _blendFilter = [[MIBlendFilter alloc] init];
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = (int)((_frontImage.sourceImage.size.height / _frontImage.sourceImage.size.width) * width);

    CGFloat nativeScale = [UIScreen mainScreen].nativeScale;
    
    _blendFilter.outputFrame = CGRectMake(0, 200, width * nativeScale, height * nativeScale);
    _blendFilter.blendMode = MIBlendModeMultiply;

    _displayView = [[MIView alloc] initWithFrame:self.view.bounds];
    _displayView.clearColor = MTLClearColorMake(0, 104.0/255.0, 55.0/255.0, 1);
    
    [self.view addSubview:_displayView];

    [_frontImage addConsumer:_blendFilter];
    [_backImage addConsumer:_blendFilter];
    [_blendFilter addConsumer:_displayView];
    
    [_frontImage processingImage];
    [_backImage processingImage];
    [self configSubViews];
}


- (void)configSubViews {
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    
    _blendModeArray = @[@"正常", @"正片叠底", @"滤色", @"强光", @"变亮", @"线性光", @"颜色减淡", @"柔光", @"亮光", @"线性加深", @"颜色加深", @"变暗", @"差值", @"排除",];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 90, width) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.center = CGPointMake(width * 0.5, height - 80);
    _tableView.transform = CGAffineTransformMakeRotation(-M_PI/2);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(50, height - 50, width - 100, 50)];
    [_slider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];
    _slider.maximumValue = 1.0;
    _slider.minimumValue = 0.0;
    _slider.value = 1.0;
    [self.view addSubview:_slider];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _blendModeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }

    cell.textLabel.text = _blendModeArray[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _blendFilter.blendMode = indexPath.row;
    [_frontImage processingImage];
    [_backImage processingImage];
}

- (void)sliderDidChange:(UISlider *)slider {
    _blendFilter.intensity = slider.value;
    [_frontImage processingImage];
    [_backImage processingImage];
    
//    UIImage *processImage = [_blendFilter imageFromCurrentFrame];
//    NSLog(@"processingImage = %@", processImage);
}

@end
