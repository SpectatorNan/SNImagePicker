//
//  SNImagePreviewViewController.h
//  SNIconPickerDemo
//
//  Created by Spectator on 16/9/1.
//  Copyright © 2016年 Spectator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNImagePreviewViewController : UIViewController

// 所有图片模型数组
@property (nonatomic, strong) NSMutableArray *models;
// 所有图片数组
@property (nonatomic, strong) NSMutableArray *photos;
// 用户点击的图片的索引
@property (nonatomic, assign) NSInteger currentIndex;
// 是否返回原图
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;

@end
