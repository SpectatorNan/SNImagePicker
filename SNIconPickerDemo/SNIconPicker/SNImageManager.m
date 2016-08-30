//
//  SNImageManager.m
//  SNIconPickerDemo
//
//  Created by Spectator on 16/8/30.
//  Copyright © 2016年 Spectator. All rights reserved.
//

#import "SNImageManager.h"
#import <Photos/Photos.h>
#import "SNAlbumModel.h"


@interface SNImageManager ()

#pragma mark -- out
@property (nonatomic, assign) BOOL sortAscendingByModificationDate;
- (BOOL)getAuthorizationStatus;

@end


static CGFloat SNScreenWidth;
static CGFloat SNScreenScale;


@implementation SNImageManager


+ (instancetype)manager {
    
    static SNImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[SNImageManager alloc] init];
    
        
        SNScreenScale = [UIScreen mainScreen].scale;
        SNScreenWidth = [UIScreen mainScreen].bounds.size.width;
    });
    
    return manager;
}

/**
 *  获取是否授权
 *
 *  @return 授权状态
 */
- (BOOL)getAuthorizationStatus {
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        return YES;
    }
    
    return NO;
}

#pragma mark -- get Album

// 获取相册数组
- (void)getCameraRollAlbum:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void(^)(SNAlbumModel *))completion {
    
    __block SNAlbumModel *albumModel;
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    
    if (!allowPickingVideo) {
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",PHAssetMediaTypeVideo];
    }
    
    if (!allowPickingImage) {
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",PHAssetMediaTypeImage];
    }
    
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:self.sortAscendingByModificationDate]];
    //获取系统相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHAssetCollection *collection in smartAlbums) {
        
        if ([collection.localizedTitle isEqualToString:@"Camera Roll"] || [collection.localizedTitle isEqualToString:@"相机胶卷"] ||  [collection.localizedTitle isEqualToString:@"所有照片"] || [collection.localizedTitle isEqualToString:@"All Photos"]) {
            
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            
            albumModel = [self modelWithResult:fetchResult name:collection.localizedTitle];
            
            if (completion) {
                completion(albumModel);
            }
            
            break;
        }
    }
}

- (void)getAllAlbums:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^)(NSArray<SNAlbumModel *> *))completion {
    
    NSMutableArray *albums = [NSMutableArray array];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    
    if (!allowPickingVideo) {
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",PHAssetMediaTypeVideo];
    }
    
    if (!allowPickingImage) {
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",PHAssetMediaTypeImage];
    }
    
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:self.sortAscendingByModificationDate]];
//    获取系统相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    获取自定义相册
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    for (PHAssetCollection *collection in smartAlbums) {
        
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        
        if (fetchResult.count < 1) {
            continue;
        }
        
        if ([collection.localizedTitle containsString:@"Deleted"] || [collection.localizedTitle isEqualToString:@"最近删除"]) {
        continue;
        }
        // 判断是否是系统相册并放在数组最前面
        if ([collection.localizedTitle isEqualToString:@"Camera Roll"] || [collection.localizedTitle isEqualToString:@"相机胶卷"] ||  [collection.localizedTitle isEqualToString:@"所有照片"] || [collection.localizedTitle isEqualToString:@"All Photos"]) {
            
            [albums insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle] atIndex:0];
        } else {
            
            [albums addObject:[self modelWithResult:fetchResult name:collection.localizedTitle]];
        }

    }
    
    for (PHAssetCollection *collection in topLevelUserCollections) {
        
        PHFetchResult *fetch = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        
        if (fetch.count < 1) {
            continue;
        }
        
        [albums addObject:[self modelWithResult:fetch name:collection.localizedTitle]];
    }
    
    if (completion && albums.count > 0) {
        completion(albums);
    }
}

#pragma mark -- get photo
// 获取照片数组

- (void)getPhotosFromFetch:(PHFetchResult *)result allowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void(^)(NSArray<SNAlbumModel *> *))completion {
    
    NSMutableArray *photos = [NSMutableArray array];
    
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        PHAsset *asset = (PHAsset *)obj;
        
        SNAssetModelMediaType type = SNAssetModelMediaTypePhoto;
        
        if (asset.mediaType == PHAssetMediaTypeAudio) {
            type = SNAssetModelMediaTypeAudio;
        } else if (asset.mediaType == PHAssetMediaTypeVideo) {
            type = SNAssetModelMediaTypeVideo;
        }
        
        if (!allowPickingImage && type == SNAssetModelMediaTypePhoto) {
            return ;
        }
        
        if (!allowPickingVideo && type == SNAssetModelMediaTypeVideo) {
            return;
        }
        
        NSString *timeLength = type == SNAssetModelMediaTypeVideo ? [NSString stringWithFormat:@"%0.0f",asset.duration] : @"";
        timeLength = [self getNewTimeFromDurationSecond:timeLength.integerValue];
    }];
    
}

#pragma mark -- data handler

- (SNAlbumModel *)modelWithResult:(PHFetchResult *)result name:(NSString *)name {
    
    SNAlbumModel *model = [[SNAlbumModel alloc] init];
    
    model.result = result;
    model.name = name;
        
    model.count = result.count;
    
    return model;
}


- (NSString *)getNewTimeFromDurationSecond:(NSInteger)duration {
    NSString *newTime;
    if (duration < 10) {
        newTime = [NSString stringWithFormat:@"0:0%zd",duration];
    } else if (duration < 60) {
        newTime = [NSString stringWithFormat:@"0:%zd",duration];
    } else {
        NSInteger min = duration / 60;
        NSInteger sec = duration - (min * 60);
        if (sec < 10) {
            newTime = [NSString stringWithFormat:@"%zd:0%zd",min,sec];
        } else {
            newTime = [NSString stringWithFormat:@"%zd:%zd",min,sec];
        }
    }
    return newTime;
}
@end
