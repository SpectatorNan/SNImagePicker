//
//  SNIconPicker.m
//  SNIconPickerDemo
//
//  Created by Spectator on 16/8/29.
//  Copyright © 2016年 Spectator. All rights reserved.
//

#import "SNIconPicker.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SNToastView.h"

@interface SNIconPicker ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>


- (UIWindow *)currentVisibleWindow;
- (UIViewController *)currentVisibleController;
@end

@implementation SNIconPicker

#pragma mark -- init method
- (instancetype)initWithDelegate:(id<SNIconPickerDelegate>)delegate {
    
    self = [super init];
    
    if (self) {
        
        self.delegate = delegate;
    }
    
    return self;
}

#pragma mark -- show method

- (void)show
{
    [self showFromView:self.currentVisibleController.view];
}

- (void)showFromView:(UIView *)view {
    
    if (self.takePhotoButtonStyle == SNIconPickerPhotoButtonStyleAlertSheet) {
        
        [self showAlertController:view];
    }
}

- (void)showAlertController:(UIView *)view {
    
    UIAlertController *alertController = [[UIAlertController alloc] init];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self takePhotoFromCamera];
    }];
    UIAlertAction *selectFromLibraryAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self takePhotoFromLibrary];
    }];
    
    
    [alertController addAction:cancelAction];
    [alertController addAction:takePhotoAction];
    [alertController addAction:selectFromLibraryAction];
    
    [self.currentVisibleController presentViewController:alertController animated:YES completion:nil];
}


#pragma mark -- private

- (UIWindow *)currentVisibleWindow {
    
    NSEnumerator *frontToBackWindows = [UIApplication sharedApplication].windows.reverseObjectEnumerator;
    
    for (UIWindow *window in frontToBackWindows) {
        
        BOOL windowOnMainScreen = window.screen == [UIScreen mainScreen];
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            return window;
        }
    }
    
    return [[[UIApplication sharedApplication] delegate] window];
}

- (UIViewController *)currentVisibleController {
    
    UIViewController *topController = self.currentVisibleWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

#pragma mark -- action handler

- (void)takePhotoFromCamera {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *imagePicker = [UIImagePickerController new];
        imagePicker.allowsEditing = self.iconEditMode != SNIconEditModeNone;
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        
        
        [self.currentVisibleController presentViewController:imagePicker animated:YES completion:nil];
    } else {
        
        [SNToastView sn_showToastTitle:@"当前设备不支持拍照" inView:self.currentVisibleController.view];
    }
}

- (void)takePhotoFromLibrary {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *imagePicker = [UIImagePickerController new];
        imagePicker.allowsEditing = self.iconEditMode != SNIconEditModeNone;
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
//        imagePicker.mediaPicker = self;
//        [self delegatePerformWillPresentImagePicker:imagePicker];
        [self.currentVisibleController presentViewController:imagePicker animated:YES completion:nil];
    } else {
        
        [SNToastView sn_showToastTitle:@"无法读取相册" inView:self.currentVisibleController.view];
    }
}

@end
