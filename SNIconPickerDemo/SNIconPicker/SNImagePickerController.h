//
//  SNImagePickerController.h
//  SNIconPickerDemo
//
//  Created by Spectator on 16/9/1.
//  Copyright © 2016年 Spectator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SNImagePickerControllerDelegate <NSObject>



@end


@interface SNImagePickerController : UINavigationController



@property (nonatomic, assign) NSUInteger maxImageCount;


@property (nonatomic, weak) id<SNImagePickerControllerDelegate> imagePickerDelegate;

@property (nonatomic, strong) UIColor *naviColor;

@property (nonatomic, strong) UIColor *naviTintColor;

@property (nonatomic, assign) BOOL statusBarLight;

@end



@interface SNAlbumPickerController : UIViewController

@property (nonatomic,assign) NSUInteger  columnNumber;

@end
