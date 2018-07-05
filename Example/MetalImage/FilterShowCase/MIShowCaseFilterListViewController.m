//
//  MIShowCaseFilterListViewController.m
//  MetalImage
//
//  Created by zsr on 2018/6/18.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIShowCaseFilterListViewController.h"
#import "MIShowCaseFilterViewController.h"

@interface MIShowCaseFilterListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MIShowCaseFilterListViewController

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
        case MIShowCaseFilterTypeMirror: title = @"Mirror"; break;
        case MIShowCaseFilterTypeLookupTable: title = @"LookupTable"; break;
        case MIShowCaseFilterTypePixellation: title = @"Pixellation"; break;
        case MIShowCaseFilterTypeHalftone: title = @"Halftone"; break;
        case MIShowCaseFilterTypeCrosshatch: title = @"Crosshatch"; break;
        case MIShowCaseFilterTypeEmboss: title = @"Emboss"; break;
        case MIShowCaseFilterTypePerlinNoise: title = @"PerlinNoise"; break;
        case MIShowCaseFilterTypePixellatePosition: title = @"PixellatePosition"; break;
        case MIShowCaseFilterTypePolarPixellate: title = @"PolarPixellate"; break;
        case MIShowCaseFilterTypePolkaDot: title = @"PolkaDot"; break;
        case MIShowCaseFilterTypeSketch: title = @"Sketch"; break;
        case MIShowCaseFilterTypeThresholdSketch: title = @"ThresholdSketch"; break;
        case MIShowCaseFilterTypeToon: title = @"Toon"; break;
        case MIShowCaseFilterTypeSmoothToon: title = @"SmoothToon"; break;
        case MIShowCaseFilterTypeCGAColorspace: title = @"CGAColorspace"; break;
        case MIShowCaseFilterTypePosterize: title = @"Posterize"; break;
        case MIShowCaseFilterTypeSwirl: title = @"Swirl"; break;
        case MIShowCaseFilterTypeBulgeDistortion: title = @"BulgeDistortion"; break;
        case MIShowCaseFilterTypePinchDistortion: title = @"PinchDistortion"; break;
        case MIShowCaseFilterTypeStretchDistortion: title = @"StretchDistortion"; break;
        case MIShowCaseFilterTypeSphereRefraction: title = @"SphereRefraction"; break;
        case MIShowCaseFilterTypeGlassSphere: title = @"GlassSphere"; break;
        case MIShowCaseFilterTypeKuwahara: title = @"Kuwahara"; break;
        case MIShowCaseFilterTypeKuwaharaRadius3: title = @"KuwaharaRadius3"; break;
        case MIShowCaseFilterTypeVignette: title = @"Vignette"; break;
            
        default:
            break;
    }

    cell.textLabel.text = title;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MIShowCaseFilterTypeNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    MIShowCaseFilterViewController *vc = [[MIShowCaseFilterViewController alloc] initWithFilterType:row];
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
