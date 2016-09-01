//
//  SNImagePickerController.m
//  SNIconPickerDemo
//
//  Created by Spectator on 16/9/1.
//  Copyright © 2016年 Spectator. All rights reserved.
//

#import "SNImagePickerController.h"
#import "SNImageManager.h"



#define kNavigationBarBackColor [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0]
#define kOkBtnColorNormal [UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:1.0];
#define kOkBtnColorDisabled [UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:0.5];


@interface SNImagePickerController ()
#pragma mark -- in
{
    NSTimer * _timer;
    UILabel * _tipLable;
}
#pragma mark -- out
// 用户选取的照片数组
@property (nonatomic, strong) NSMutableArray *selectedModels;
// 是否允许选取原图
@property (nonatomic, assign) BOOL allowPickingOriginalPhoto;
// 是否允许选取视频
@property (nonatomic, assign) BOOL allowPickingVideo;
// 是否允许选图图片
@property (nonatomic, assign) BOOL allowPickingImage;
// 超时 dismiss HUD ,默认15秒
@property (nonatomic, assign) NSInteger timeout;
// 默认 828
@property (nonatomic, assign) CGFloat photoWidth;
// 默认 600
@property (nonatomic, assign) CGFloat photoPreviweMaxWidth;
// 是否按照修改日期排序
@property (nonatomic, assign) BOOL sortAscendingByModificationDate;

@end

@implementation SNImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self defaultConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)defaultConfig {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.translucent = YES;
    
    self.navigationBar.barTintColor = kNavigationBarBackColor;
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

//    设置状态栏颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
//    获取系统item修改attributes属性
    UIBarButtonItem *barItem;
    
    if (iOS9Later) {
        barItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[SNImagePickerController class]]];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        barItem = [UIBarButtonItem appearanceWhenContainedIn:[SNImagePickerController class], nil];
#pragma clang diagnostic pop
    }
    
    NSDictionary *textAttributes = @{
                                     NSForegroundColorAttributeName : [UIColor whiteColor],
                                     NSFontAttributeName : [UIFont systemFontOfSize:14]
                                     };
    [barItem setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
}


- (instancetype)initWithMaxImageCount:(NSUInteger)maxImageCount delegate:(id<SNImagePickerControllerDelegate>)delegate {
    
    return [self initWithMaxImageCount:maxImageCount columnNumber:4 delegate:delegate];
}

- (instancetype)initWithMaxImageCount:(NSUInteger)maxImageCount columnNumber:(NSUInteger)columnNumber delegate:(id<SNImagePickerControllerDelegate>)delegate {
    
    SNAlbumPickerController *albumVC = [[SNAlbumPickerController alloc] init];
    albumVC.columnNumber = columnNumber;
    
    self = [super initWithRootViewController:albumVC];
    
    if (self) {
        // 最多选取为9张
        self.maxImageCount = maxImageCount > 0 && maxImageCount < 10 ? maxImageCount : 9;
        self.imagePickerDelegate = delegate;
        self.selectedModels = [NSMutableArray array];
        
        //        默认允许用户选择视频和原图，可以在该方法之后自定义设置
        self.allowPickingImage = YES;
        self.allowPickingVideo = YES;
        self.allowPickingOriginalPhoto = YES;
        
        self.timeout = 15;
        self.photoWidth = 828.0;
        self.photoPreviweMaxWidth = 600.0;
        self.sortAscendingByModificationDate = YES;
        
        
        if (![[SNImageManager manager] getAuthorizationStatus]) {
            _tipLable = [[UILabel alloc] init];
            _tipLable.frame = CGRectMake(8, 0, self.view.frame.size.width - 16, 300);
            _tipLable.textAlignment = NSTextAlignmentCenter;
            _tipLable.numberOfLines = 0;
            _tipLable.font = [UIFont systemFontOfSize:16];
            _tipLable.textColor = [UIColor blackColor];
            NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
            if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
            _tipLable.text = [NSString stringWithFormat:@"请在%@的\"设置-隐私-照片\"选项中，\r允许%@访问你的手机相册。",[UIDevice currentDevice].model,appName];
            [self.view addSubview:_tipLable];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(observeAuthrizationStatusChange) userInfo:nil repeats:YES];
        } else {
            
            [self pushToPhotoPickerVC];
        }
    }
    
    return self;
}


- (void)pushToPhotoPickerVC {
    
}

- (void)observeAuthrizationStatusChange {
    
    if ([[SNImageManager manager] getAuthorizationStatus]) {
        
    }
}

@end


@implementation SNAlbumPickerController

@end
