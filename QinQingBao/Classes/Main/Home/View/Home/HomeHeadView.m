//
//  HomeHeadView.m
//  QinQingBao
//
//  Created by 董徐维 on 16/5/5.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HomeHeadView.h"

#import "HomePicModel.h"

#import "MassageTableViewController.h"

#import "AdvertisementController.h"

#import "MarketViewController.h"

#import "ClasslistViewController.h"

#import "MarketClasslistController.h"
#import "HealthPlanController.h"

#import "ShopDetailViewController.h"

#import "MarketDeatilViewController.h"

@interface HomeHeadView ()<UIScrollViewDelegate>
{
    UIPageControl *pageControl;
    
    NSTimer *timer;
}

@end

@implementation HomeHeadView


- (IBAction)masageHandler:(id)sender
{
    MassageTableViewController *view = [[MassageTableViewController alloc] init];
    [self.nav pushViewController:view animated:YES];
}

- (IBAction)healthHandler:(id)sender
{
    ClasslistViewController *vc = [[ClasslistViewController alloc] init];
    [self.nav pushViewController:vc animated:YES];
}

- (IBAction)marketHandler:(id)sender {
    MarketClasslistController *view = [[MarketClasslistController alloc] init];
    [self.nav pushViewController:view animated:YES];
}

- (IBAction)onlineHandler:(id)sender {
    [NoticeHelper AlertShow:@"暂未开通此功能" view:nil];
}

- (IBAction)healthPlanHandler:(id)sender {
    if (![SharedAppUtil defaultCommonUtil].userVO )
        return [MTNotificationCenter postNotificationName:MTNeedLogin object:nil userInfo:nil];
    HealthPlanController *view = [[HealthPlanController alloc] init];
    [self.nav pushViewController:view animated:YES];
}

/**
 *  初始化突变轮播播放器
 */
-(void)initImagePlayer
{
    [timer invalidate];

    self.imagePlayer.bounces = YES;
    self.imagePlayer.pagingEnabled = YES;
    self.imagePlayer.delegate = self;
    self.imagePlayer.userInteractionEnabled = YES;
    self.imagePlayer.showsHorizontalScrollIndicator = NO;
    
    // 初始化 pagecontrol
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((MTScreenW - 100)/2, 130, 100, 18)]; // 初始化mypagecontrol
    [pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
    [pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    pageControl.numberOfPages = [_slideImages count];
    pageControl.currentPage = 0;
    [self addSubview:pageControl];
    
    //解决初始化imageplayer可能发生偏移的问题
    self.imagePlayer.width = MTScreenW;
    
    // 创建图片 imageview
    for (int i = 0; i < _slideImages.count; i++)
    {
        HomePicModel *item = _slideImages[i];
        NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_AdvanceImg,item.bc_value]];
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"advplaceholderImage"]];
        imageView.frame = CGRectMake((MTScreenW * i) + MTScreenW, 0, MTScreenW, self.imagePlayer.height);
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.tag = i;
        imageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
        [imageView addGestureRecognizer:singleTap];
        [self.imagePlayer addSubview:imageView];
    }
    // 取数组最后一张图片 放在第0页
    HomePicModel *item = _slideImages[_slideImages.count - 1];
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_AdvanceImg,item.bc_value]];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"advplaceholderImage"]];
    imageView.frame = CGRectMake(0, 0, MTScreenW, self.imagePlayer.height); // 添加最后1页在首页 循环
    [self.imagePlayer addSubview:imageView];
    
    // 取数组第一张图片 放在最后1页
    HomePicModel *item0 = _slideImages[0];
    imageView = [[UIImageView alloc] init];
    NSURL *iconUrl1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_AdvanceImg,item0.bc_value]];
    [imageView sd_setImageWithURL:iconUrl1 placeholderImage:[UIImage imageWithName:@"advplaceholderImage"]];
    imageView.frame = CGRectMake((MTScreenW * ([_slideImages count] + 1)) , 0, MTScreenW, self.imagePlayer.height);
    [self.imagePlayer addSubview:imageView];
    
    [self.imagePlayer setContentSize:CGSizeMake(MTScreenW * ([_slideImages count] + 2), self.imagePlayer.height)];
    [self.imagePlayer setContentOffset:CGPointMake(0, 0)];
    [self.imagePlayer scrollRectToVisible:CGRectMake(MTScreenW, 0, MTScreenW, self.imagePlayer.height) animated:NO];
    
    [self initTimer];
}

#pragma mark 初始化轮播广告定时器
/**
 *  初始化定时器
 **/
-(void)initTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

-(void)timerFireMethod:(NSTimer *)theTimer
{
    [self turn2Page:pageControl.currentPage + 1];
}

/**
 *  轮播广告点击事件
 *
 *  @param tap tap description
 *  @param idx idx description
 */
-(void)onClickImage:(UITapGestureRecognizer *)tap
{
    HomePicModel *item = _advArr[tap.view.tag];
    if (item.bc_article_url.length == 0)
        return;
    
    // 43 超声理疗 44 精准健康监测分析 45疾病易感性基因检测
    
    if ([item.bc_type_app_id isEqualToString:@"43"])
    {
        ShopDetailViewController *view = [[ShopDetailViewController alloc] init];
        view.iid = item.bc_item_id;
        view.hidesBottomBarWhenPushed = YES;
        [self.nav pushViewController:view animated:YES];

    }
    else if ([item.bc_type_app_id isEqualToString:@"44"])
    {
        MarketDeatilViewController *view = [[MarketDeatilViewController alloc] init];
        view.iid = item.bc_item_id;
        view.hidesBottomBarWhenPushed = YES;
        [self.nav pushViewController:view animated:YES];
    }
    else if ([item.bc_type_app_id isEqualToString:@"45"])
    {
        MarketDeatilViewController *view = [[MarketDeatilViewController alloc] init];
        view.iid = item.bc_item_id;
        view.hidesBottomBarWhenPushed = YES;
        [self.nav pushViewController:view animated:YES];
    }
    else
    {
        AdvertisementController *adver = [[AdvertisementController alloc] init];
        adver.item = item;
        [self.nav pushViewController:adver animated:YES];
    }
}

#pragma mark -- UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = self.imagePlayer.frame.size.width;
    int page = floor((self.imagePlayer.contentOffset.x - pagewidth/([_slideImages count]+2))/pagewidth)+1;
    page --;  // 默认从第二页开始
    pageControl.currentPage = page;
}

/**
 * 手动时暂停
 **/
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [timer invalidate];
}

/**
 * scrollview 委托函数
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = self.imagePlayer.frame.size.width;
    int currentPage = floor((self.imagePlayer.contentOffset.x - pagewidth/ ([_slideImages count]+2)) / pagewidth) + 1;
    if (currentPage==0)
    {
        [self.imagePlayer scrollRectToVisible:CGRectMake(MTScreenW * [_slideImages count],0,MTScreenW,self.imagePlayer.height) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==([_slideImages count]+1))
    {
        [self.imagePlayer scrollRectToVisible:CGRectMake(MTScreenW,0,MTScreenW,self.imagePlayer.height) animated:NO]; // 最后+1,循环第1页
    }
    
    [self initTimer];
}

/**
 * pagecontrol 选择器的方法
 */
- (void)turn2Page:(NSInteger)idx
{
    if (idx == _slideImages.count)
        idx = 0;
    pageControl.currentPage = idx;
    [self.imagePlayer scrollRectToVisible:CGRectMake(MTScreenW * (idx+1) , 0 ,MTScreenW, self.imagePlayer.height) animated:YES];
}

@end

