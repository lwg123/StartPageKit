//
//  SPIntroductionPage.m
//  StartPageAdvertisingDemo
//
//  Created by weiguang on 2019/3/26.
//  Copyright © 2019 duia. All rights reserved.
//

#import "SPIntroductionPage.h"

@interface SPIntroductionPage ()<UIScrollViewDelegate>
{
    NSArray       * _spBgViewArr;
    NSInteger       _spCenterPageIndex;
    AVPlayer      * _spPlayer;
    NSTimer       * _spTimer;
    AVPlayerLayer * _spPlayerLayer;
}
@end

@implementation SPIntroductionPage

-(instancetype)init {
    if (self = [super init]) {
        [self spInitSelf];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addPageScroll];
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopTimer];
}

- (void)spBringSubViewToFront{
    [self.view bringSubviewToFront:self.pageScrollView];
    [self.view bringSubviewToFront:_pageControl];
    [self.view bringSubviewToFront:self.enterBtn];
}

- (void)addVideo{
    if(!_videoUrl){
        return;
    }
    AVPlayerItem * xyPlayerItem = [AVPlayerItem playerItemWithURL:_videoUrl];
    _spPlayer = [AVPlayer playerWithPlayerItem:xyPlayerItem];
    _spPlayer.volume = self.volume;
    
    _spPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_spPlayer];
    _spPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _spPlayerLayer.frame = self.view.layer.bounds;
    [self.view.layer addSublayer:_spPlayerLayer];
    
    [_spPlayer play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movidePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_spPlayer.currentItem];
    
    [self spBringSubViewToFront];
}

- (void)setVolume:(float)volume {
    _volume = volume;
    _spPlayer.volume = volume;
}

- (void)addBackgroundViews{
    CGRect frame = self.view.bounds;
    NSMutableArray * tmpArr = [NSMutableArray new];
    [[[_backgroundImgArr reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * suffix;
        if([obj componentsSeparatedByString:@"."]){
            suffix = [obj componentsSeparatedByString:@"."][1];
            
        }
        UIImageView * imgView = [[UIImageView alloc]init];
        if([suffix isEqualToString:@"gif"]){
            NSString * gifImgName = [obj componentsSeparatedByString:@"."][0];
            imgView.image = [UIImage sp_setAnimatedGIFWithGifName:gifImgName];
        }else {
            imgView.image = [UIImage imageNamed:obj];
            
        }
        
        imgView.frame = frame;
        imgView.tag = idx + 1;
        [tmpArr addObject:imgView];
        [self.view addSubview:imgView];
        
    }];
    _spBgViewArr = [[tmpArr reverseObjectEnumerator] allObjects];
    [self.view bringSubviewToFront:self.pageScrollView];
    [self.view bringSubviewToFront:_pageControl];
}


#pragma mark -- Getter & Setter Method ---
- (void)setBackgroundImgArr:(NSArray *)backgroundImgArr {
    _backgroundImgArr = backgroundImgArr;
    [self addBackgroundViews];
}


- (void)setCoverImgArr:(NSArray *)coverImgArr {
    _coverImgArr = coverImgArr;
    [self reloadPage];
}

-(void)setCoverTitlesArr:(NSArray *)coverTitlesArr {
    _coverTitlesArr = coverTitlesArr;
    [self reloadPage];
}

- (void)setLabelAttributesDic:(NSDictionary *)labelAttributesDic {
    _labelAttributesDic = labelAttributesDic;
    [self reloadCoverTitles];
}

- (void)setVideoUrl:(NSURL *)videoUrl {
    _videoUrl = videoUrl;
    [self addVideo];
}

- (void)setAutoScrolling:(BOOL)autoScrolling {
    _autoScrolling = autoScrolling;
    if(!_spTimer&&_autoScrolling){
        [self startTimer];
    }
}


- (NSArray *)spGetPageArr {
    if([self spGetPagesNum] <1){
        return nil;
    }
    if(_pageArr){
        return _pageArr;
    }
    NSMutableArray * tmpArr = [[NSMutableArray alloc]init];
    if(_coverImgArr){
        [_coverImgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tmpArr addObject:[self getCoverImgViewWithImgName:obj]];
        }];
    }else if(_coverTitlesArr){
        [_coverTitlesArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tmpArr addObject:[self getPageWithTitle:obj]];
        }];
    }
    _pageArr = tmpArr;
    return  _pageArr;
}

- (void)reloadPage{
    _pageControl.numberOfPages = [self spGetPagesNum];
    _pageScrollView.contentSize = [self spGetScrollContentSize];
    __block CGFloat x = 0;
    NSArray * xyPageArr = [self spGetPageArr];
    [xyPageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView * view = (UIView *)obj;
        view.frame = CGRectOffset(view.frame, x, 0);
        [self.pageScrollView addSubview:view];
        x += view.frame.size.width;
        if(idx == xyPageArr.count - 1){
            [view addSubview:self.enterBtn];
        }
        
    }];
    
    if(_pageControl.numberOfPages == 1){
        _enterBtn.alpha = 1;
        _pageControl.alpha = 0;
    }
    if(self.pageScrollView.contentSize.width == self.pageScrollView.frame.size.width){
        self.pageScrollView.contentSize = CGSizeMake(self.pageScrollView.contentSize.width + 1, self.pageScrollView.contentSize.height);
    }
    
}



#pragma mark -----  初始化  --------
- (void)spInitSelf {
    _autoScrolling = NO;
    _autoLoopPlayVideo = YES;
    [self setupEnterBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(spApplicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

- (void)setupEnterBtn {
    if(!self.enterBtn){
        self.enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.enterBtn setTitle:@"进入" forState:UIControlStateNormal];
        self.enterBtn.layer.borderWidth = 0.5;
        self.enterBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        self.enterBtn.hidden = NO;
        self.enterBtn.frame = [self spLayoutEnterBtnFrame];
    }
    [self.enterBtn addTarget:self action:@selector(spEnter:) forControlEvents:UIControlEventTouchUpInside];
    self.enterBtn.alpha = 0;
}


- (CGRect)spLayoutEnterBtnFrame {
    CGSize size = self.enterBtn.bounds.size;
    if (CGSizeEqualToSize(size,CGSizeZero)) {
        size = CGSizeMake(self.view.frame.size.width * 0.6, 40);
    }
    return CGRectMake(self.view.frame.size.width/2 -size.width/2,_pageControl.frame.origin.y - size.height/2, size.width, size.height);
}

- (void)addPageScroll{
    self.pageScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.pageScrollView.delegate = self;
    self.pageScrollView.pagingEnabled = YES;
    self.pageScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.pageScrollView];
    _pageControl = [[UIPageControl alloc]initWithFrame:[self layoutPageControlFrame]];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:_pageControl];
    
    
}

- (CGRect)layoutPageControlFrame{
    CGRect xyFrame = CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width, 30);
    return CGRectOffset(xyFrame,self.pageControlOffSet.x, self.pageControlOffSet.y);
}

- (void)reloadCoverTitles{
    for(UILabel * label in _pageArr){
        
        CGFloat height = 30;
        NSString * text = [label.attributedText string];
        if([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
            CGSize size = [text sizeWithAttributes:_labelAttributesDic];
            height = size.height;
        }
        label.attributedText = [[NSAttributedString alloc]initWithString:text attributes:_labelAttributesDic];
    }
}


#pragma mark --- action事件 ----
- (void)spEnter:(id)obj {
    [self stopTimer];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(spIntroduceViewEnterTap:)]) {
        [self.delegate spIntroduceViewEnterTap:obj];
    }
}

- (void)movidePlayDidEnd:(NSNotification *)notification{
    if(_autoLoopPlayVideo){
        AVPlayerItem * item = [notification object];
        [item seekToTime:kCMTimeZero];
        [_spPlayer play];
    }else{
        [self spEnter:nil];
    }
}

- (void)spApplicationWillEnterForeground:(id)sender{
    [_spPlayer play];
}


#pragma mark -- 其他方法 --
- (NSInteger)spGetPagesNum{
    if(_coverImgArr){
        return _coverImgArr.count;
        
    }else if(_coverTitlesArr){
        return _coverTitlesArr.count;
        
    }
    return 0;
}

- (CGSize)spGetScrollContentSize{
    UIView *view = [[self spGetPageArr] firstObject];
    return CGSizeMake(view.frame.size.width* _pageArr.count, view.frame.size.height);
}

- (UIView *)getCoverImgViewWithImgName:(NSString *)imgName {
    UIImageView * imgView = [[UIImageView alloc]init];
    if([imgName componentsSeparatedByString:@"."].count>1&&[[imgName componentsSeparatedByString:@"."][1] isEqualToString:@"gif"]){
        
        NSString * gifImgName = [imgName componentsSeparatedByString:@"."][0];
        imgView.image = [UIImage sp_setAnimatedGIFWithGifName:gifImgName];
    }else{
        imgView.image = [UIImage imageNamed:imgName];
    }
    
    imgView.userInteractionEnabled = YES;
    CGSize size = self.view.bounds.size;
    
    imgView.frame = CGRectMake(0,0, size.width, size.height);
    return imgView;
}

- (UIView *)getPageWithTitle:(NSString *)title{
    CGSize size = self.view.frame.size;
    CGRect rect;
    CGFloat height = 30;
    if([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
        CGSize size = [title sizeWithAttributes:_labelAttributesDic];
        height = size.height;
    }
    rect = CGRectMake(0, size.height - height - 100, size.width, height);
    UILabel * label = [[UILabel alloc]initWithFrame:rect];
    label.textAlignment = NSTextAlignmentCenter;
    label.attributedText = [[NSAttributedString alloc]initWithString:title attributes:_labelAttributesDic];
    
    return  label;
}


- (void)startTimer{
    if(_autoScrolling){
        _spTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(spOnTimer) userInfo:nil repeats:YES];
    }
}

- (void)spOnTimer{
    CGRect frame = self.pageScrollView.frame;
    frame.origin.x = frame.size.width * (_pageControl.currentPage + 1);
    frame.origin.y = 0;
    if(frame.origin.x >= self.pageScrollView.contentSize.width){
        frame.origin.x = 0;
    }
    [self.pageScrollView scrollRectToVisible:frame animated:YES];
}

-(void)stopTimer {
    [_spTimer invalidate];
    _spTimer = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_spPlayer pause];
    _spPlayer = nil;
    [self stopTimer];
}

#pragma mark----------代理位置------------------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/self.view.frame.size.width;
    CGFloat xyAlpha =  1-(scrollView.contentOffset.x - index*self.view.bounds.size.width)/self.view.bounds.size.width;
    if([_spBgViewArr count] >index){
        UIView * view = [_spBgViewArr objectAtIndex:index];
        if(view){
            view.alpha = xyAlpha;
        }
    }
    
    [_pageControl setCurrentPage:[self getCurrentPage]];
    [self pageControlChangePage:scrollView];
    if(scrollView.isTracking){
        [self stopTimer];
    }else{
        if(!_spTimer){
            [self startTimer];
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if([scrollView.panGestureRecognizer translationInView:scrollView.superview].x<0){
        if(![self xyIsGoOnNext:_pageControl]&&self.isAutoEnterOn){
            [self spEnter:nil];
        }
    }
}

- (NSInteger)getCurrentPage{
    return self.pageScrollView.contentOffset.x/self.view.bounds.size.width;
}

- (void)pageControlChangePage:(UIScrollView *)pageScrollView{
    
    if([self xyIsLastPage:_pageControl]){
        if(!self.isAutoEnterOn){
            self.pageScrollView.bounces = NO;
        }
        if(_pageControl.alpha == 1){
            [UIView animateWithDuration:1 animations:^{
                self->_enterBtn.alpha = 1;
                self->_pageControl.alpha = 0;
            }];
        }
    }else{
        if(_pageControl.alpha == 0){
            [UIView animateWithDuration:1 animations:^{
                self->_enterBtn.alpha = 0;
                self->_pageControl.alpha = 1;
            }];
        }
    }
}

- (BOOL)xyIsLastPage:(UIPageControl *)pageControl{
    return pageControl.numberOfPages == pageControl.currentPage + 1;
}

- (BOOL)xyIsGoOnNext:(UIPageControl *)pageControl{
    return pageControl.numberOfPages>pageControl.currentPage + 1;
}

@end
