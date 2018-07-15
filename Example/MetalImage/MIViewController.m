//
//  MIViewController.m
//  MetalImage
//
//  Created by zsr on 2018/6/24.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIViewController.h"

@interface MIViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation MIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"demo";
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    _titles = @[@"Filter List",
                @"Simple Video",
                @"Simple CaptureImage",
                @"Simple Image",
                @"Simple Gif",
                @"Simple VideoFile",
                @"Simple Blend"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha = 1.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    UIViewController *vc;
    switch (row) {
        case 0:
            vc = [[NSClassFromString(@"MIShowCaseFilterListViewController") alloc] init];
            break;
            
        case 1:
            vc = [[NSClassFromString(@"MISimpleVideoFilterViewController") alloc] init];
            break;
            
        case 2:
            vc = [[NSClassFromString(@"MISimpleCaptureImageViewController") alloc] init];
            break;
            
        case 3:
            vc = [[NSClassFromString(@"MISimpleImageFilterViewController") alloc] init];
            break;
            
        case 4:
            vc = [[NSClassFromString(@"MISimpleGifFilterViewController") alloc] init];
            break;
            
        case 5:
            vc = [[NSClassFromString(@"MISimpleVideoFileFilterViewController") alloc] init];
            break;
            
        case 6:
            vc = [[NSClassFromString(@"MISimpleBlendFilterViewController") alloc] init];
            break;
            
        default:
            vc = [[NSClassFromString(@"MIShowCaseFilterListViewController") alloc] init];
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
