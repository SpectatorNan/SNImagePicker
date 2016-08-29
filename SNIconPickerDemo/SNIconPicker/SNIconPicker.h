//
//  SNIconPicker.h
//  SNIconPickerDemo
//
//  Created by Spectator on 16/8/29.
//  Copyright © 2016年 Spectator. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "SNIconPickerConfig.h"



@protocol SNIconPickerDelegate;
@interface SNIconPicker : NSObject
- (instancetype)initWithDelegate:(id<SNIconPickerDelegate>)delegate;
- (void)show;
- (void)showFromView:(UIView *)view;

@property (nonatomic, weak) id<SNIconPickerDelegate> delegate;
@property (nonatomic, assign) SNIconPickerPhotoButtonStyle takePhotoButtonStyle;
@property (nonatomic, assign) SNIconEditMode iconEditMode;
@end


@protocol SNIconPickerDelegate <NSObject>



@end
