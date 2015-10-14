//
//  HealthMonitorViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/13.
//  Copyright (c) 2015年 董徐维. All rights reserved.  ttttjjj swy1234567
//


#import "HealthMonitorViewController.h"
#import "AddMemberViewController.h"

@interface HealthMonitorViewController ()

@property (nonatomic, retain) AddMemberViewController *addView;
@end

@implementation HealthMonitorViewController
{
    UIPageControl *pageControl;
    UILabel *titleLab;
}

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
    
    [self setupPageControl];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (pageControl)
        pageControl.hidden = NO;
    if (titleLab)
        titleLab.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (pageControl)
        pageControl.hidden = YES;
    if (titleLab)
        titleLab.hidden = YES;
}
/**
 *  添加pageControl
 */
- (void)setupPageControl
{
    if (!pageControl)
        pageControl = [[UIPageControl alloc] init];
    // 1.添加
    pageControl.numberOfPages = 4;
    pageControl.x = MTScreenW/2;
    pageControl.centerY = 38;
    
    if (!titleLab)
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.x = MTScreenW/2 - 40;

    [self.navigationController.navigationBar addSubview:titleLab];
    
    //    self.navigationItem.titleView.x = -20;
    [self.navigationController.navigationBar addSubview:pageControl];
    
    // 2.设置圆点的颜色
    pageControl.currentPageIndicatorTintColor = HMColor(253, 253, 253); // 当前页的小圆点颜色
    pageControl.pageIndicatorTintColor = HMColor(189, 189, 189); // 非当前页的小圆点颜色
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addHandler:)];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat doublePage = scrollView.contentOffset.x / scrollView.width;
    int intPage = (int)(doublePage + 0.5);
    // 设置页码
    pageControl.currentPage = intPage;
    titleLab.text = [NSString stringWithFormat:@"当前第%d页",intPage];
}

-(void)addHandler:(id)sender
{
    if (self.addView == nil) {
        self.addView = [[AddMemberViewController alloc] init];
    }
    [self.navigationController pushViewController:self.addView animated:YES];
}

@end
