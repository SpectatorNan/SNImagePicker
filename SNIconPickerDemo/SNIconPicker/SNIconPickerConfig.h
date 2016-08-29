//
//  SNIconPickerConfig.h
//  SNIconPickerDemo
//
//  Created by Spectator on 16/8/29.
//  Copyright © 2016年 Spectator. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SNIconPickerPhotoButtonStyle) {
    SNIconPickerPhotoButtonStyleAlertSheet,
    SNIconPickerPhotoButtonStyleImageButton
};

typedef NS_ENUM(NSUInteger, SNIconPickerType) {
    SNIconPickerTypeIcon,
    SNIconPickerTypeImage,
    SNIconPickerTypeViedo,
    SNIconPickerTypeImageAndVideo
};


typedef NS_ENUM(NSUInteger, SNIconEditMode) {
    SNIconEditModeStandard,
    SNIconEditModeCircle,
    SNIconEditModeCustom,
    SNIconEditModeNone
};


@protocol SNIconPickerConfig <NSObject>

@end
