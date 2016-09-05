//
//  ViewController.m
//  SNIconPickerDemo
//
//  Created by Spectator on 16/8/29.
//  Copyright © 2016年 Spectator. All rights reserved.
//

#import "ViewController.h"
#import "SNIconPicker.h"
#import "SNImageManager.h"

@interface ViewController ()<SNIconPickerDelegate>

@property (nonatomic, strong) SNIconPicker *pick;

@property (nonatomic, strong) SNImageManager *imgMgr;

@end

@implementation ViewController

- (SNImageManager *)imgMgr {
    
    if (!_imgMgr) {
        _imgMgr = [SNImageManager manager];
    }
    
    return _imgMgr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)alertSheet:(id)sender {
    
//    SNIconPicker *picker = [[SNIconPicker alloc] initWithDelegate:self];
//    picker.takePhotoButtonStyle = SNIconPickerPhotoButtonStyleAlertSheet;
//    self.pick = picker;
//    [picker show];

    [self albumsLog];
}



- (void)albumsLog {
    
    [self.imgMgr getCameraRollAlbumAllowPickingVideo:NO allowPickingImage:YES completion:^(SNAlbumModel *album) {
//        NSLog(@"%@",album);
    }];
    
    [self.imgMgr getAllAlbumsAllowPickingVideo:YES allowPickingImage:YES completion:^(NSArray<SNAlbumModel *> *albums) {
        NSLog(@"%@",albums);
    }];
}
@end
