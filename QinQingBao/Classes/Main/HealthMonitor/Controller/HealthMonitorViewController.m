//
//  HealthMonitorViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/13.
//  Copyright (c) 2015年 董徐维. All rights reserved.  ttttjjj swy1234567
//


#import "HealthMonitorViewController.h"

@interface HealthMonitorViewController ()

@end

@implementation HealthMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView setContentSize:CGSizeMake(MTScreenW, MTScreenH)];
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.backgroundColor = HMGlobalBg;
    [self.view addSubview:self.scrollView];
    [self setupScrollView];
}

#pragma mark - 滑动tab视图代理方法
#pragma mark pageControl
/**
 *  添加UISrollView
 */
- (void)setupScrollView
{
    // 2.添加view
    for (int i = 0; i< 4 ; i++)
    {
        HealthPageViewController *page = [[HealthPageViewController alloc] init];
        page.view.frame = CGRectMake(MTScreenW *i, 0, MTScreenW, MTViewH - MTNavgationHeadH);
        
        [self addChildViewController:page];
        [self.scrollView  addSubview:page.view];
    }
    
    // 3.设置其他属性
    self.scrollView .contentSize = CGSizeMake(4 * self.scrollView.width, 0);
    self.scrollView.scrollEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.directionalLockEnabled = YES;
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"健康监护";
}

@end
