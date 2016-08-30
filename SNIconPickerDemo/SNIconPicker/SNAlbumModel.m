//
//  SNAlbumModel.m
//  SNIconPickerDemo
//
//  Created by Spectator on 16/8/30.
//  Copyright © 2016年 Spectator. All rights reserved.
//

#import "SNAlbumModel.h"

@implementation SNAlbumModel

- (void)setResult:(id)result {
    
    _result = result;
    
    BOOL allowPickingImage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tz_allowPickingImage"] isEqualToString:@"1"];
    BOOL allowPickingVideo = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tz_allowPickingVideo"] isEqualToString:@"1"];
//    [[SNImageManager manager] getAssetsFromFetchResult:result allowPickingVideo:allowPickingVideo allowPickingImage:allowPickingImage completion:^(NSArray<TZAssetModel *> *models) {
//        _models = models;
//        if (_selectedModels) {
//            [self checkSelectedModels];
//        }
//    }];
    
}

- (void)setSelectedModels:(NSArray *)selectedModels {
    _selectedModels = selectedModels;
    if (_models) {
        [self checkSelectedModels];
    }
}

- (void)checkSelectedModels {
    self.selectedCount = 0;
    NSMutableArray *selectedAssets = [NSMutableArray array];
    for (SNAssetModel *model in _selectedModels) {
        [selectedAssets addObject:model.asset];
    }
    for (SNAssetModel *model in _models) {
//        if ([[SNImageManager manager] isAssetsArray:selectedAssets containAsset:model.asset]) {
//            self.selectedCount ++;
//        }
    }
}
@end

@implementation SNAssetModel

+ (instancetype)modelWithAsset:(id)asset type:(SNAssetModelMediaType)type{
    SNAssetModel *model = [[SNAssetModel alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    model.type = type;
    return model;
}

+ (instancetype)modelWithAsset:(id)asset type:(SNAssetModelMediaType)type timeLength:(NSString *)timeLength {
    SNAssetModel *model = [self modelWithAsset:asset type:type];
    model.timeLength = timeLength;
    return model;
}

@end