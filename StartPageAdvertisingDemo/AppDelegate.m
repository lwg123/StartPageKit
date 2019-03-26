//
//  AppDelegate.m
//  StartPageAdvertisingDemo
//
//  Created by weiguang on 2019/3/19.
//  Copyright © 2019 duia. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController/SPRootTabbarController.h"
#import "ViewController.h"
#import "SPLaunchViewController.h"

@interface AppDelegate ()<SPLaunchDelegate>
{
    SPLaunchViewController *_spLaunchVC;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyWindow];
    
   // 启动页 -默认
   // [self spNormalLaunch];
    
    // 广告
   // [self adLaunch];
    
    // gif
    [self setupGif];
    
    return YES;
}


#pragma mark ------------- 不同启动页类型 -----------------
#pragma mark - 启动页 默认
- (void)spNormalLaunch {
    SPRootTabbarController *rootVC = [[SPRootTabbarController alloc] init];
    _spLaunchVC = [[SPLaunchViewController alloc] initWithRootVC:rootVC LaunchType:SPLaunchNormal];
    _spLaunchVC.normalDuration = 2;
    
    // 本地图片
   // _spLaunchVC.normalImgName = @"LaunchImg";
    
    // 网络图片
    _spLaunchVC.normalImgUrl = @"http://img.zcool.cn/community/011c9655935c3c6ac7253264bee6ef.jpg";
    self.window.rootViewController = _spLaunchVC;
}

#pragma mark - 启动页 广告
- (void)adLaunch {
    SPRootTabbarController *rootVC = [[SPRootTabbarController alloc] init];
    _spLaunchVC = [[SPLaunchViewController alloc] initWithRootVC:rootVC LaunchType:SPLaunchAD];
    _spLaunchVC.adDuration = 5;
    _spLaunchVC.delegate = self;
    _spLaunchVC.adActionUrl = @"https://github.com/lwg123";
    _spLaunchVC.isSkip = YES;
    
    // 网络图片
    //_spLaunchVC.adImgUrl = @"http://img.zcool.cn/community/011c9655935c3c6ac7253264bee6ef.jpg";
    // 本地
    _spLaunchVC.adLocalImgName = @"XYAd.png";
    self.window.rootViewController = _spLaunchVC;
}

#pragma mark - 启动页 gif图片
- (void)setupGif {
    SPRootTabbarController *rootVC = [[SPRootTabbarController alloc] init];
    _spLaunchVC = [[SPLaunchViewController alloc] initWithRootVC:rootVC LaunchType:SPLaunchGif];
    // 本地
   // _spLaunchVC.gifImgName = @"qidong";
    
    //网络
    _spLaunchVC.gifImgUrl = @"http://images2015.cnblogs.com/blog/607542/201601/607542-20160123090832343-133952004.gif";
    self.window.rootViewController = _spLaunchVC;
    
}

- (void)launchAdImgViewAction:(id)sender withObject:(id)object {
    
}

@end
