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
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"demo";
    [self.view addSubview:self.tableView];
    
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[
                    @"Filter List",
                    @"SimpleVideoFilter",
                    @"SimpleCaptureImage",
                    @"SimpleImageFilter",
                    @"SimpleGifFilter",
                    @"SimpleVideoFileFilter"
                    ];
    }
    return _titles;
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
            vc = [[NSClassFromString(@"MEShowCaseFilterListViewController") alloc] init];
            break;
            
            case 1:
            vc = [[NSClassFromString(@"MESimpleVideoFilterViewController") alloc] init];
            break;
            
            case 2:
            vc = [[NSClassFromString(@"MESimpleCaptureImageViewController") alloc] init];
            break;
            
            case 3:
            vc = [[NSClassFromString(@"MESimpleImageFilterViewController") alloc] init];
            break;
            
            case 4:
            vc = [[NSClassFromString(@"MESimpleGifFilterViewController") alloc] init];
            break;
            
            case 5:
            vc = [[NSClassFromString(@"MESimpleVideoFileFilterViewController") alloc] init];
            break;
            
        default:
            vc = [[NSClassFromString(@"MEShowCaseFilterListViewController") alloc] init];
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}



@end
