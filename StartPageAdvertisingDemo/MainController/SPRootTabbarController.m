//
//  SPRootTabbarController.m
//  StartPageAdvertisingDemo
//
//  Created by weiguang on 2019/3/19.
//  Copyright © 2019 duia. All rights reserved.
//

#import "SPRootTabbarController.h"
#import "SPFirstViewController.h"
#import "SPSecondViewController.h"
#import "SPThirdViewController.h"


@interface SPRootTabbarController ()

@end

@implementation SPRootTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建子控制器
    [self setupChildController];
}

- (void)setupChildController {
    //修改下面文字大小和颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11],NSFontAttributeName,[UIColor colorWithRed:44/255.0 green:185/255.0 blue:176/255.0 alpha:1],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11],NSFontAttributeName,[UIColor colorWithRed:44/255.0 green:185/255.0 blue:176/255.0 alpha:1],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    SPFirstViewController *infoVC = [[SPFirstViewController alloc] init];
    infoVC.title = @"首页";
    UIImage *image = [[UIImage imageNamed:@"icon_tabbar_homepage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage = [[UIImage imageNamed:@"icon_tabbar_homepage_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    infoVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:image selectedImage:selectImage];
    
    //应用
    SPSecondViewController *appCtrl = [[SPSecondViewController alloc] init];
    appCtrl.title = @"商家";
    UIImage *image1 = [[UIImage imageNamed:@"icon_tabbar_merchant_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage1 = [[UIImage imageNamed:@"icon_tabbar_merchant_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    appCtrl.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"商家" image:image1 selectedImage:selectImage1];
    
    //我的
    SPThirdViewController *myCtrl = [[SPThirdViewController alloc] init];
    myCtrl.title = @"我";
    UIImage *image2 = [[UIImage imageNamed:@"icon_tabbar_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage2 = [[UIImage imageNamed:@"icon_tabbar_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myCtrl.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我" image:image2 selectedImage:selectImage2];
    
    //创建数组
    NSArray *viewCtrls = @[infoVC,appCtrl,myCtrl];
    
    //创建可变数组,存储导航控制器
    NSMutableArray *navs = [NSMutableArray arrayWithCapacity:viewCtrls.count];
    
    //创建二级控制器导航控制器
    for (UIViewController *ctrl in viewCtrls) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        
        //将导航控制器加入到数组中
        [navs addObject:nav];
    }
    
    self.viewControllers = navs;
    
}

@end
