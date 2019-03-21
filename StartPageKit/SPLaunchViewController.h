//
//  SPLaunchViewController.h
//  StartPageAdvertisingDemo
//
//  Created by weiguang on 2019/3/19.
//  Copyright © 2019 duia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPRootTabbarController.h"

typedef NS_ENUM(NSInteger,SPLaunchType){
    SPLaunchNormal,//默认启动图
    SPLaunchGuide,//向导启动图
    SPLaunchAD,//广告启动图
    SPLaunchGif,//gif启动图
    SPLaunchAutoRoll//自动滚动图片
};

// 代理
@protocol SPLaunchDelegate <NSObject>

- (void)launchAdImgViewAction:(id)sender withObject:(id)object;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SPLaunchViewController : UIViewController

@property (nonatomic,strong)UIViewController * rootVC;//根视图控制器
@property (nonatomic,assign)SPLaunchType launchType; //启动图类型
@property (nonatomic,weak) id<SPLaunchDelegate> delegate;
@property (nonatomic,strong)UIButton * enterBtn;//进入按钮
@property (nonatomic,strong)UIColor       * frontViewBgColor;//最上面浮层试图

//默认系统样式启动图
@property (nonatomic,strong)NSString * normalImgName;//本地图片名称
@property (nonatomic,strong)NSString * normalImgUrl;//网络
@property (nonatomic,assign)NSInteger  normalDuration;//延长时间

//广告
@property (nonatomic,strong)NSTimer * adTimer;//广告定时器
@property (nonatomic,strong)UILabel * timerLabel;//倒数时间label
@property (nonatomic,assign)BOOL      isCloseTimer;//是否关不启动定时器
@property (nonatomic,strong)UIImageView * adImgView;//广告图
@property (nonatomic,strong)UITapGestureRecognizer * spSkipLabelTap;//跳过手势
@property (nonatomic,strong)NSString * adImgUrl;//广告网络图片
@property (nonatomic,strong)NSString * adLocalImgName;//广告本地图片
@property (nonatomic,assign)NSInteger  adDuration;//显示时间
@property (nonatomic,strong)NSString * adActionUrl;//详情页weburl
@property (nonatomic,strong)NSString * adTitle;//详情页广告标题
@property (nonatomic,assign)BOOL       isSkip;//是否显示跳过按钮

// gif
@property (nonatomic,strong)NSString * gifImgName;//gif本地名称
@property (nonatomic,strong)NSString * gifImgUrl;//gif网络url
@property (nonatomic,strong)UIView   * gifFrontView;//浮层
@property (nonatomic,assign)BOOL       isHideEnterBtn;//是否显示进入按钮



//init
- (instancetype)initWithRootVC:(UIViewController *)rootVC LaunchType:(SPLaunchType)launchType;

//重置开启定时器
- (void)sp_startFire;

@end

NS_ASSUME_NONNULL_END
