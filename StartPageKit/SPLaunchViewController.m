//
//  SPLaunchViewController.m
//  StartPageAdvertisingDemo
//
//  Created by weiguang on 2019/3/19.
//  Copyright © 2019 duia. All rights reserved.
//

#import "SPLaunchViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImage+SPGif.h"

#define SPScreenBounds [UIScreen mainScreen].bounds

@interface SPLaunchViewController ()

@end

@implementation SPLaunchViewController

- (instancetype)initWithRootVC:(UIViewController *)rootVC LaunchType:(SPLaunchType)launchType
{
    if (self = [super init]) {
        _rootVC = rootVC;
        _launchType = launchType;
        _adDuration = 2;
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    switch (_launchType) {
            case SPLaunchNormal: {
                [self spLayoutNormalLaunch];
            }
            break;
            
            case SPLaunchAD: {
                
                [self layoutADImgView];
                [self layoutTimerLabel];
            }
            break;
        case SPLaunchGif: {
            
            [self setupEnterBtn];
            [self setupGifImage];
        }
            break;
            
        default:
            break;
    }
}

// 默认
- (void)spLayoutNormalLaunch {
    
    UIImageView * launchImgView = [[UIImageView alloc]initWithFrame:SPScreenBounds];
    [self.view addSubview:launchImgView];
    
    if(self.normalImgName.length >0){
        [launchImgView setImage:[UIImage imageNamed:self.normalImgName]];
        self.adTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(releaseAll) userInfo:nil repeats:NO];
        if(self.isCloseTimer == YES){
            [self.adTimer setFireDate:[NSDate distantFuture]];
        }
        
        
    }else if (self.normalImgUrl.length > 0) {
        __weak typeof(self) weakSelf = self;
        [launchImgView sd_setImageWithURL:[NSURL URLWithString:self.normalImgUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            weakSelf.adTimer = [NSTimer scheduledTimerWithTimeInterval:self.normalDuration target:self selector:@selector(releaseAll) userInfo:nil repeats:NO];
            if (weakSelf.isCloseTimer) {
                [weakSelf.adTimer setFireDate:[NSDate distantFuture]];
            }
        }];
    }
    
}

// 广告
- (void)layoutADImgView {
    self.adImgView = [[UIImageView alloc] initWithFrame:SPScreenBounds];
    self.adImgView.userInteractionEnabled = YES;
    [self.view addSubview:self.adImgView];
    
    UITapGestureRecognizer * adTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adTap:)];
    [self.adImgView addGestureRecognizer:adTap];
    
    __weak typeof(self) weakSelf = self;
    if (self.adImgUrl.length > 0) {
        [self.adImgView sd_setImageWithURL:[NSURL URLWithString:_adImgUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (weakSelf.adTimer) {
                [weakSelf.adTimer fire];
            }
        }];
    }else if (self.adLocalImgName.length > 0) {
        self.adImgView.image = [UIImage imageNamed:_adLocalImgName];
        if (weakSelf.adTimer) {
            [weakSelf.adTimer fire];
        }
    }
    
}

- (void)layoutTimerLabel {
    self.timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(SPScreenBounds.size.width - 90, 20, 80, 30)];
    self.timerLabel.backgroundColor = [UIColor colorWithRed:125/256.0 green:125/256.0  blue:125/256.0  alpha:0.5];
    self.timerLabel.textColor = [UIColor whiteColor];
    self.timerLabel.textAlignment = NSTextAlignmentCenter;
    self.timerLabel.layer.masksToBounds = YES;
    self.timerLabel.layer.cornerRadius = 5;
    self.timerLabel.userInteractionEnabled = YES;
    if (self.isSkip) {// 可以点击
        self.timerLabel.text = [NSString stringWithFormat:@"跳过 %ld",self.adDuration];
       UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(skipTap)];
       [self.timerLabel addGestureRecognizer:tap];
    }else {
        self.timerLabel.text = [NSString stringWithFormat:@"剩余 %ld",self.adDuration];
    }
    [self.view addSubview:_timerLabel];
    
    if (!self.isCloseTimer) {
        self.adTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
}

// gif
- (void)setupGifImage {
    self.gifFrontView = [[UIView alloc] initWithFrame:SPScreenBounds];
    UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:SPScreenBounds];
    if (self.gifImgName.length > 0) {
//        NSString * retinaPath = [[NSBundle mainBundle] pathForResource:self.gifImgName ofType:@"gif"];
//        NSData * data = [NSData dataWithContentsOfFile:retinaPath];
        gifImageView.image = [UIImage sp_setAnimatedGIFWithGifName:self.gifImgName];
        
    }else if (self.gifImgUrl.length > 0){
        //[gifImageView sd_setImageWithURL:[NSURL URLWithString:self.gifImgUrl]];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.gifImgUrl]];
        gifImageView.image = [UIImage sp_setAnimatedGIFWithData:data];
    }
    
    [self.view addSubview:gifImageView];
    
    if(self.frontViewBgColor){
        self.gifFrontView.backgroundColor = self.frontViewBgColor;
        
    }else{
        self.gifFrontView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9  blue:0.9  alpha:0.5];
    }
    
    if(!self.isHideEnterBtn){
        [self.gifFrontView addSubview:self.enterBtn];
        self.enterBtn.tintColor = [UIColor blueColor];
    }
    [self.view addSubview:self.gifFrontView];
    
}

- (void)setupEnterBtn{
    self.enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.enterBtn.frame = CGRectMake(SPScreenBounds.size.width/2 - 100, SPScreenBounds.size.height - 120, 200, 40);
    self.enterBtn.tintColor = [UIColor lightGrayColor];
    [self.enterBtn setTitle:@"进入应用" forState:UIControlStateNormal];
    [self.enterBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.enterBtn.layer.masksToBounds = YES;
    self.enterBtn.layer.cornerRadius = 20;
    self.enterBtn.layer.borderWidth = 1.0;
    self.enterBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.enterBtn addTarget:self action:@selector(skipTap) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark --- action事件 -------
- (void)releaseAll {
    if(self.adTimer !=nil){
        [self.adTimer invalidate];
        self.adTimer = nil;
    }
    
    [self setRootVC];
}

- (void)adTap:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(launchAdImgViewAction:withObject:)]) {
        [self.delegate launchAdImgViewAction:sender withObject:self];
    }
}

- (void)skipTap {
    [self releaseAll];
}

- (void)timerAction {
    self.adDuration--;
    if (self.adDuration < 0) {
        [self.adTimer invalidate];
        self.view.window.rootViewController = self.rootVC;
    }
    if (self.isSkip) {
        self.timerLabel.text = [NSString stringWithFormat:@"跳过 %ld",self.adDuration];
    }else {
        self.timerLabel.text = [NSString stringWithFormat:@"剩余 %ld",self.adDuration];
    }
}

#pragma mark -- 其他操作 --
- (void)setRootVC {
    
    self.view.window.rootViewController = self.rootVC;
}

- (void)sp_startFire {
    if (self.launchType == SPLaunchAD) {
        self.adTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }else if (self.launchType == SPLaunchNormal) {
        [self performSelector:@selector(releaseAll) withObject:nil afterDelay:self.normalDuration];
    }
}

-(void)dealloc {
    if (self.adTimer != nil) {
        [self.adTimer invalidate];
        self.adTimer = nil;
    }
}

@end
