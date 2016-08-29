//
//  SNToastView.m
//  SNIconPickerDemo
//
//  Created by Spectator on 16/8/29.
//  Copyright © 2016年 Spectator. All rights reserved.
//

#import "SNToastView.h"


#define kSuperHeight view.bounds.size.height
#define kSuperWidth view.bounds.size.width

#define kMainHeight [UIScreen mainScreen].bounds.size.height
#define kMainWidth [UIScreen mainScreen].bounds.size.width

#define kToastHeight 30.0
#define kToastFont [UIFont boldSystemFontOfSize:14]

@implementation SNToastView

+ (void)sn_showToastTitle:(NSString *)title inView:(UIView *)view {
    
    UIView *backGroundView = [[UIView alloc] initWithFrame:view.bounds];
    [view addSubview:backGroundView];
    
    CGSize labelSize = [SNToastView calculateStringSizeWithString:title];
    CGFloat y = kSuperHeight*0.85;
    CGFloat x = (kMainWidth - labelSize.width)/2;
    CGFloat height = labelSize.height+30;
    CGFloat width = labelSize.width+20;
    
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    middleView.backgroundColor = [UIColor lightGrayColor];
    middleView.clipsToBounds = YES;
    middleView.layer.cornerRadius = 5.f;
    
    [backGroundView addSubview:middleView];
    
    UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, labelSize.width, labelSize.height)];
    toastLabel.text = title;
    toastLabel.font = kToastFont;

    
    [middleView addSubview:toastLabel];
    
    CGFloat delayInsSeconds = 2.f;
    dispatch_time_t removeTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInsSeconds * NSEC_PER_SEC));
    dispatch_after(removeTime, dispatch_get_main_queue(),^{
        [UIView animateWithDuration:1.f animations:^{
            middleView.alpha = 0;
        }];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [backGroundView removeFromSuperview];
    });
    
    
}

+ (CGSize)calculateStringSizeWithString:(NSString *)string {
    NSDictionary *attribute = @{
                                NSFontAttributeName : kToastFont
                                };
//    MAXFLOAT
    return [string boundingRectWithSize:CGSizeMake(MAXFLOAT, kToastHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
}

@end
