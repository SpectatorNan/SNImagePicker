//
//  SNPhotoPickerViewController.h
//  SNIconPickerDemo
//
//  Created by Spectator on 16/9/1.
//  Copyright © 2016年 Spectator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SNAlbumModel;
@interface SNPhotoPickerViewController : UIViewController

@property (nonatomic, assign) BOOL isFirstAppear ;

@property (nonatomic, assign) NSInteger columnNumber;

@property (nonatomic, strong) SNAlbumModel *model;

@end
