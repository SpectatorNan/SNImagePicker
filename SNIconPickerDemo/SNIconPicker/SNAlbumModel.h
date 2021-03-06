//
//  SNAlbumModel.h
//  SNIconPickerDemo
//
//  Created by Spectator on 16/8/30.
//  Copyright © 2016年 Spectator. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SNAssetModelMediaType) {
    SNAssetModelMediaTypePhoto,
    SNAssetModelMediaTypeVideo,
    SNAssetModelMediaTypeAudio
};

@interface SNAlbumModel : NSObject

@property (nonatomic, strong) NSString *name;        ///< The album name
@property (nonatomic, assign) NSInteger count;       ///< Count of photos the album contain
@property (nonatomic, strong) id result;             ///< PHFetchResult<PHAsset>

@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) NSArray *selectedModels;
@property (nonatomic, assign) NSUInteger selectedCount;

@end

@interface SNAssetModel : NSObject

@property (nonatomic, strong) id asset;             ///< PHAsset or ALAsset
@property (nonatomic, assign) BOOL isSelected;      ///< The select status of a photo, default is No
@property (nonatomic, assign) SNAssetModelMediaType type;
@property (nonatomic, copy) NSString *timeLength;

/// Init a photo dataModel With a asset
/// 用一个PHAsset/ALAsset实例，初始化一个照片模型
+ (instancetype)modelWithAsset:(id)asset type:(SNAssetModelMediaType)type;
+ (instancetype)modelWithAsset:(id)asset type:(SNAssetModelMediaType)type timeLength:(NSString *)timeLength;

@end