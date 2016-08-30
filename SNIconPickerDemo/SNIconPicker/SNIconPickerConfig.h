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



#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

@protocol SNIconPickerConfig <NSObject>

@end
