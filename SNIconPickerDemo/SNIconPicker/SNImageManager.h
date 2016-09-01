//
//  SNImageManager.h
//  SNIconPickerDemo
//
//  Created by Spectator on 16/8/30.
//  Copyright © 2016年 Spectator. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "SNIconPickerConfig.h"
#import "SNAlbumModel.h"
#import <Photos/Photos.h>

@interface SNImageManager : NSObject

@property (nonatomic, assign) BOOL sortAscendingByModificationDate;

- (BOOL)getAuthorizationStatus;
/// Default is 600px / 默认600像素宽
@property (nonatomic, assign) CGFloat photoPreviewMaxWidth;

- (void)getCameraRollAlbum:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void(^)(SNAlbumModel *album))completion;
- (void)getAllAlbums:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^)(NSArray<SNAlbumModel *> *albums))completion;

- (void)getAssetsFromFetch:(PHFetchResult *)result allowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void(^)(NSArray<SNAlbumModel *> * assets))completion;
- (void)getAssetFromFetchResult:(PHFetchResult *)result atIndex:(NSInteger )index allowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void(^)(SNAssetModel *model))completion;

- (void)getPhotosBytesWithArray:(NSArray *)photos completion:(void(^)(NSString *totalBytes))comletion;

- (void)getPostImageWithAlbumModel:(SNAlbumModel *)model completion:(void(^)(UIImage *))completion;
- (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset completion:(void(^)(UIImage *image, NSDictionary* info, BOOL isDegraded))completion;
- (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat )photoWidth completion:(void(^)(UIImage *image, NSDictionary* info, BOOL isDegraded))completion;
- (void)getOriginalPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo, NSDictionary *info))completion;

- (void)savePhotoWithImage:(UIImage *)image comletion:(void(^)())completion;

- (void)getVideoWithAsset:(PHAsset *)asset completion:(void (^)(AVPlayerItem * playerItem, NSDictionary * info))completion;

- (void)exportVideoOutPathWithAsset:(PHAsset *)asset completion:(void (^)(NSString *outputPath))completion ;


- (BOOL)isAssetArray:(NSArray *)assets containAsset:(PHAsset *)asset;

- (NSString *)getAssetIdentifier:(PHAsset  * )asset;


+ (instancetype)manager;

@end
