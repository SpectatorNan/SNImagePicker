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
/// Default is 600px / 默认600像素宽
@property (nonatomic, assign) CGFloat photoPreviewMaxWidth;

#pragma mark -- in

@end


static CGFloat SNScreenWidth;
static CGFloat SNScreenScale;
static CGSize  SNMinAssetGridThumbnailSize;

@implementation SNImageManager


+ (instancetype)manager {
    
    static SNImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[SNImageManager alloc] init];
    
        
        SNScreenScale = [UIScreen mainScreen].scale;
        SNScreenWidth = [UIScreen mainScreen].bounds.size.width;
        
        
        CGFloat margin = 4;
        CGFloat itemWH = (SNScreenWidth - 3*margin) / 2;
        SNMinAssetGridThumbnailSize = CGSizeMake(itemWH * SNScreenScale, itemWH * SNScreenScale);
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
- (void)getCameraRollAlbum:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void(^)(SNAlbumModel *album))completion {
    
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

- (void)getAllAlbums:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^)(NSArray<SNAlbumModel *> *albums))completion {
    
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

#pragma mark -- get asset
// 获取照片数组

- (void)getAssetsFromFetch:(PHFetchResult *)result allowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void(^)(NSArray<SNAlbumModel *> * assets))completion {
    
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
        
        [photos addObject:[SNAssetModel modelWithAsset:asset type:type timeLength:timeLength]];
    }];
    
    
    if (completion) {
        completion(photos);
    }
}

// 获取下标为index的单个照片
// 如果索引越界，在回调中返回nil
- (void)getAssetFromFetchResult:(PHFetchResult *)result atIndex:(NSInteger )index allowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void(^)(SNAssetModel *model))completion {
    
    PHAsset *asset;
    
    @try {
        asset = result[index];
    }
    @catch (NSException *exception) {
        if (completion) {
            completion(nil);
        }
        return;
    }
   
    SNAssetModelMediaType type = SNAssetModelMediaTypePhoto;
    if (asset.mediaType == PHAssetMediaTypeAudio) {
        type = SNAssetModelMediaTypeAudio;
    } else if (asset.mediaType == PHAssetMediaTypeVideo) {
        type = SNAssetModelMediaTypeVideo;
    }
    
    NSString *timeLength = type == SNAssetModelMediaTypeVideo ? [NSString stringWithFormat:@"%0.0f",asset.duration] : @"";
    timeLength = [self getNewTimeFromDurationSecond:timeLength.integerValue];
    
    SNAssetModel *model = [SNAssetModel modelWithAsset:asset type:type timeLength:timeLength];
    
    if (completion) {
        completion(model);
    }
}

#pragma mark -- get photo
// 获取一组照片的大小
- (void)getPhotosBytesWithArray:(NSArray *)photos completion:(void(^)(NSString *totalBytes))comletion {
    
    __block NSInteger dataLength = 0;
    __block NSInteger assetCount = 0;
    
    for (int i = 0; i < photos.count; i ++) {
        
        SNAssetModel *model = photos[i];
        
        [[PHImageManager defaultManager] requestImageDataForAsset:model.asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
           
            if (model.type != SNAssetModelMediaTypeVideo) {
                dataLength += imageData.length;
            }
            
            assetCount ++;
            
            if (assetCount >= photos.count) {
                NSString *bytes = [self getBytesFromDataLength:dataLength];
                
                if (comletion) {
                    comletion(bytes);
                }
            }
        }];
    }
    
}


- (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset completion:(void(^)(UIImage *image, NSDictionary* info, BOOL isDegraded))completion {
    
    CGFloat fullScreenWidth = SNScreenWidth;
    
    if (fullScreenWidth > _photoPreviewMaxWidth) {
        fullScreenWidth = _photoPreviewMaxWidth;
    }
    
    return [self getPhotoWithAsset:asset photoWidth:fullScreenWidth completion:completion];
}

- (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat )photoWidth completion:(void(^)(UIImage *image, NSDictionary* info, BOOL isDegraded))completion {
    
    CGSize imageSize;
    
    if (photoWidth < SNScreenWidth && photoWidth < _photoPreviewMaxWidth) {
        imageSize = SNMinAssetGridThumbnailSize;
    } else {
        // 除数强转float 保留结果有小数
        CGFloat aspectRatio = asset.pixelWidth / (CGFloat)asset.pixelHeight;
        CGFloat pixelWidth = photoWidth * SNScreenScale;
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        imageSize = CGSizeMake(pixelWidth, pixelHeight);
    }
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    PHImageRequestID imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        BOOL finish = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey];
        
        if (finish && result) {
            
            result = [self fixOrientation:result];
            
            if (completion) {
                completion(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            }
            
                    }
        if ([info objectForKey:PHImageResultIsInCloudKey] && !result) {
            
            PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
            
            option.networkAccessAllowed = YES;
            option.resizeMode = PHImageRequestOptionsResizeModeFast;
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                UIImage *resultImage = [UIImage imageWithData:imageData];
                resultImage = [self scaleImage:resultImage toSize:imageSize];
                
                if (resultImage) {
                    resultImage = [self fixOrientation:resultImage];
                    
                    if (completion) {
                        completion(resultImage,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                    }
                }
            }];
        }

    }];
    
    return imageRequestID;
}

// 获取封面图
- (void)getPostImageWithAlbumModel:(SNAlbumModel *)model completion:(void(^)(UIImage *))completion {
    
    id asset = [model.result lastObject];
    
    if (!self.sortAscendingByModificationDate) {
        asset = [model.result firstObject];
    }
    
    [[SNImageManager manager] getPhotoWithAsset:asset photoWidth:80 completion:^(UIImage *image, NSDictionary *info, BOOL isDegraded) {
        if (completion) {
            completion(image);
        }
    }];
}

// 获取原图
- (void)getOriginalPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo, NSDictionary *info))completion {
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        BOOL finished = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey];
        
        if (finished && result) {
            result = [self fixOrientation:result];
            
            if (completion) {
                completion(result, info);
            }
        }
    }];
}

#pragma mark -- data handler
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    if (image.size.width > size.width) {
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    } else {
        return image;
    }
}

- (NSString *)getBytesFromDataLength:(NSInteger)dataLength {
    NSString *bytes;
    if (dataLength >= 0.1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%0.1fM",dataLength/1024/1024.0];
    } else if (dataLength >= 1024) {
        bytes = [NSString stringWithFormat:@"%0.0fK",dataLength/1024.0];
    } else {
        bytes = [NSString stringWithFormat:@"%zdB",dataLength];
    }
    return bytes;
}

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


- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp) {
        return aImage;
    }
    
    
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
