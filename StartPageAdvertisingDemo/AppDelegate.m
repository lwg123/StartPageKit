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
#import "SPIntroductionPage.h"

@interface AppDelegate ()<SPLaunchDelegate,SPIntroduceDelegate>
{
    SPLaunchViewController *_spLaunchVC;
    SPIntroductionPage * _spIntroductionPage;
    NSArray *            _spCoverImgNameArr;
    NSArray *            _spBgImgNameArr;
    NSArray *            _spCoverTitleArr;
    NSURL   *            _spVideoUrl;
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
    //[self setupGif];
    
  // -引导页----
    [self setupIntroductionPageWithExampleType:3];
    
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

#pragma mark ---- 引导页 -----
- (void)setupIntroductionPageWithExampleType:(int)type {
    ViewController * spVC = [[ViewController alloc]init];
   // SPRootTabbarController *rootVC = [[SPRootTabbarController alloc] init];
    
    _spCoverImgNameArr = @[@"Guide_pages_one.png", @"Guide_pages_two.png", @"Guide_pages_three.png"];
    _spBgImgNameArr = @[@"Guide_pages_BGone.png", @"Guide_pages_BGtwo.png", @"Guide_pages_BGthree.png"];
    switch (type) {
        case 1:
            _spIntroductionPage = [self example1];
            
            break;
        case 2:
            _spIntroductionPage = [self example2];
            
            break;
        case 3:
            _spIntroductionPage = [self example3];
            
            break;
        case 4:
            _spIntroductionPage = [self example4];
            
            break;
        case 5:
            _spIntroductionPage = [self example5];
            
            break;
            
        default:
            break;
    }
    
    self.window.rootViewController = _spIntroductionPage;//只用引导页的时候打开此项/跟启动页一起用的时候注释掉
   // [self.window addSubview:_spIntroductionPage.view];
    
}

//传统引导页
- (SPIntroductionPage *)example1{
    
    //可以添加gif动态图哦
   // _spBgImgNameArr = @[@"XY01.gif",@"XY03.gif",@"XY01.gif"];
    
    SPIntroductionPage * xyPage = [[SPIntroductionPage alloc]init];
    xyPage.coverImgArr = _spBgImgNameArr;//设置浮层滚动图片数组
    xyPage.delegate = self;//进入按钮事件代理
    xyPage.autoScrolling = YES;//是否自动滚动
    //可以自定义设置进入按钮样式
    [xyPage.enterBtn setTitle:@"进入" forState:UIControlStateNormal];
    return xyPage;
}

//带浮层引导页
- (SPIntroductionPage *)example2{
    //可以添加gif动态图哦
    _spBgImgNameArr = @[@"XY01.gif",@"XY03.gif",@"XY01.gif"];
    
    SPIntroductionPage * xyPage = [[SPIntroductionPage alloc]init];
    
    xyPage.backgroundImgArr = _spBgImgNameArr;
    xyPage.coverImgArr = _spCoverImgNameArr;
    
    xyPage.delegate = self;
    
    return xyPage;
}

//浮层中自定义添加控件
- (SPIntroductionPage *)example3{
    
    SPIntroductionPage * xyPage = [[SPIntroductionPage alloc]init];
    xyPage.coverImgArr = _spCoverImgNameArr;
    xyPage.backgroundImgArr = _spBgImgNameArr;
    xyPage.delegate = self;
    [xyPage.enterBtn setTitle:@"进入" forState:UIControlStateNormal];
    
    //浮层中自定义添加空间
    [xyPage.pageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView * imgView = obj;
        NSArray * textArr = @[@"希望大家能够喜欢~",@"git:https://github.com/cryboyofyu",@"进去给个star哦~"];
        UILabel * lable1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        lable1.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,100);
        lable1.text = textArr[idx];
        lable1.textAlignment = NSTextAlignmentCenter;
        lable1.textColor = [UIColor blackColor];
        [imgView addSubview:lable1];
    }];
    return xyPage;
}

//视频
- (SPIntroductionPage *)example4{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"XYVideo" ofType:@"mp4"];
    NSLog(@"路径:%@",[NSBundle mainBundle]);
    
    _spVideoUrl = [NSURL fileURLWithPath:filePath];
    SPIntroductionPage * xyPage = [[SPIntroductionPage alloc]init];
    xyPage.videoUrl = _spVideoUrl;
    xyPage.volume = 0.7;
    xyPage.coverImgArr = _spCoverImgNameArr;
    xyPage.autoScrolling = YES;
    xyPage.delegate = self;
    return  xyPage;
}

//自定义浮层标题
- (SPIntroductionPage *)example5{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"XYVideo" ofType:@"mp4"];
    NSLog(@"路径:%@",[NSBundle mainBundle]);
    _spCoverTitleArr = @[@"年轻的你", @"健身游泳",@"一路前行!"];
    
    _spVideoUrl = [NSURL fileURLWithPath:filePath];
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(3, self.window.frame.size.height - 60, self.window.frame.size.width - 6, 50)];
    loginButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    
    [loginButton addTarget:self action:@selector(xyLogin) forControlEvents:UIControlEventTouchUpInside];
    
    SPIntroductionPage * xyPage = [[SPIntroductionPage alloc]init];
    xyPage.pageControl.hidden = YES;
    xyPage.labelAttributesDic = @{ NSFontAttributeName : [UIFont fontWithName:@"Arial-BoldMT" size:18.0],
                                     NSForegroundColorAttributeName : [UIColor whiteColor] };
    xyPage.videoUrl = _spVideoUrl;
    xyPage.coverTitlesArr = _spCoverTitleArr;
    xyPage.autoScrolling = YES;
    xyPage.pageControlOffSet = CGPointMake(0, -100);
    xyPage.delegate = self;
    
    [xyPage.view addSubview:loginButton];
    return  xyPage;
}


//自定义登录按钮
- (void)xyLogin{
    
    NSLog(@"点击了登录");
}


#pragma mark -- 代理 ---
// 点击广告页进入详情
- (void)launchAdImgViewAction:(id)sender withObject:(id)object {
    NSLog(@"进入广告详情页");
}


//进入按钮事件
- (void)spIntroduceViewEnterTap:(nonnull id)sender {
    NSLog(@"进入主页面");
    SPRootTabbarController *rootVC = [[SPRootTabbarController alloc] init];
    self.window.rootViewController = rootVC;
    _spIntroductionPage = nil;
}

@end
