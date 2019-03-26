//
//  SPIntroductionPage.h
//  StartPageAdvertisingDemo
//
//  Created by weiguang on 2019/3/26.
//  Copyright © 2019 duia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+SPGif.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SPIntroduceDelegate <NSObject>

- (void)spIntroduceViewEnterTap:(id)sender;

@end

@interface SPIntroductionPage : UIViewController

@property (nonatomic,strong)UIScrollView *pageScrollView;//浮层ScrollView
@property (nonatomic,strong)UIButton     *enterBtn;//进入按钮
@property (nonatomic,assign)BOOL          autoScrolling;//是否自动滚动
@property (nonatomic,assign)BOOL          autoLoopPlayVideo;//是否自动循环播放
@property (nonatomic,assign)BOOL          isAutoEnterOn;//是否滑到最后一张进入
@property (nonatomic,assign)CGPoint       pageControlOffSet;//pageControl默认偏移量
@property (nonatomic,strong)UIPageControl *pageControl;//引导pageControl


@property (nonatomic,strong)NSArray      *backgroundImgArr;//底层背景图数组
@property (nonatomic,strong)NSArray      *coverImgArr;//浮层图片数组
@property (nonatomic,strong)NSArray      *coverTitlesArr;//浮层文字数组
@property (nonatomic,strong)NSDictionary *labelAttributesDic;//文字特性
@property (nonatomic,assign)float   volume;//声音大小
@property (nonatomic,strong)NSURL  *videoUrl;//视频地址
@property (nonatomic,strong)NSArray *pageArr;//放置浮层view数组

@property (nonatomic,weak)  id<SPIntroduceDelegate> delegate;

- (instancetype)init;

- (void)stopTimer;


@end

NS_ASSUME_NONNULL_END
