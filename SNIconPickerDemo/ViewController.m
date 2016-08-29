//
//  ViewController.m
//  SNIconPickerDemo
//
//  Created by Spectator on 16/8/29.
//  Copyright © 2016年 Spectator. All rights reserved.
//

#import "ViewController.h"
#import "SNIconPicker.h"

@interface ViewController ()<SNIconPickerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)alertSheet:(id)sender {
    
    SNIconPicker *picker = [[SNIconPicker alloc] initWithDelegate:self];
    picker.takePhotoButtonStyle = SNIconPickerPhotoButtonStyleAlertSheet;
    
    [picker show];
}

@end
