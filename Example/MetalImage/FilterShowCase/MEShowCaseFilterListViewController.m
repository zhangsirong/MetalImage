//
//  MEShowCaseFilterListViewController.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MEShowCaseFilterListViewController.h"
#import "MEShowCaseFilterViewController.h"

@interface MEShowCaseFilterListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MEShowCaseFilterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Filter List";
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    NSInteger index = indexPath.row;
    NSString *title = @"";
    switch (index) {
        case MEShowCaseFilterTypeMirror: title = @"Mirror"; break;
        case MEShowCaseFilterTypeLookupTable: title = @"LookupTable"; break;
        case MEShowCaseFilterTypePixellation: title = @"Pixellation"; break;
        case MEShowCaseFilterTypeHalftone: title = @"Halftone"; break;
        case MEShowCaseFilterTypeCrosshatch: title = @"Crosshatch"; break;
        case MEShowCaseFilterTypeEmboss: title = @"Emboss"; break;
        case MEShowCaseFilterTypePerlinNoise: title = @"PerlinNoise"; break;
        case MEShowCaseFilterTypePixellatePosition: title = @"PixellatePosition"; break;
        case MEShowCaseFilterTypePolarPixellate: title = @"PolarPixellate"; break;
        case MEShowCaseFilterTypePolkaDot: title = @"PolkaDot"; break;
        case MEShowCaseFilterTypeSketch: title = @"Sketch"; break;
        case MEShowCaseFilterTypeThresholdSketch: title = @"ThresholdSketch"; break;
        case MEShowCaseFilterTypeToon: title = @"Toon"; break;
        case MEShowCaseFilterTypeSmoothToon: title = @"SmoothToon"; break;
        case MEShowCaseFilterTypeCGAColorspace: title = @"CGAColorspace"; break;
        case MEShowCaseFilterTypePosterize: title = @"Posterize"; break;
        case MEShowCaseFilterTypeSwirl: title = @"Swirl"; break;
        case MEShowCaseFilterTypeBulgeDistortion: title = @"BulgeDistortion"; break;
        case MEShowCaseFilterTypePinchDistortion: title = @"PinchDistortion"; break;
        case MEShowCaseFilterTypeStretchDistortion: title = @"StretchDistortion"; break;
        case MEShowCaseFilterTypeSphereRefraction: title = @"SphereRefraction"; break;
        case MEShowCaseFilterTypeGlassSphere: title = @"GlassSphere"; break;
        case MEShowCaseFilterTypeKuwahara: title = @"Kuwahara"; break;
        case MEShowCaseFilterTypeKuwaharaRadius3: title = @"KuwaharaRadius3"; break;
        case MEShowCaseFilterTypeVignette: title = @"Vignette"; break;
            
        default:
            break;
    }

    cell.textLabel.text = title;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MEShowCaseFilterTypeNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    MEShowCaseFilterViewController *vc = [[MEShowCaseFilterViewController alloc] initWithFilterType:row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 

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
