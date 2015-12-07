//
//  HealthMonitorViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/13.
//  Copyright (c) 2015年 董徐维. All rights reserved.  ttttjjj swy1234567
//


#import "HealthMonitorViewController.h"
#import "AddMemberViewController.h"
#import "FamilyTotal.h"

@interface HealthMonitorViewController ()

@property (nonatomic, retain) UIScrollView *scrollView;

@end

@implementation HealthMonitorViewController
{
    UIPageControl *pageControl;
    UILabel *titleLab;
    NSMutableArray *dataProvider;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self getDataProvider];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView setContentSize:CGSizeMake(MTScreenW, MTScreenH)];
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.backgroundColor = HMGlobalBg;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.scrollView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (pageControl)
        pageControl.hidden = NO;
    if (titleLab)
        titleLab.hidden = NO;
    
    if([SharedAppUtil defaultCommonUtil].needRefleshMonitor == YES)
        [self getDataProvider];
    
    if ([SharedAppUtil defaultCommonUtil].tabBarController.tabBar.hidden)
    {
        [SharedAppUtil defaultCommonUtil].tabBarController.tabBar.hidden = NO;
        [SharedAppUtil defaultCommonUtil].tabBarController.tabBar.height = 49;
    }
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
    pageControl.numberOfPages = dataProvider.count;
    pageControl.x = MTScreenW/2;
    pageControl.centerY = 38;
    
    if (!titleLab)
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.x = MTScreenW/2 - 65;
    
    [self.navigationController.navigationBar addSubview:titleLab];
    
    if (dataProvider.count > 1)
        [self.navigationController.navigationBar addSubview:pageControl];
    
    // 2.设置圆点的颜色
    pageControl.currentPageIndicatorTintColor = HMColor(253, 253, 253); // 当前页的小圆点颜色
    pageControl.pageIndicatorTintColor = HMColor(189, 189, 189); // 非当前页的小圆点颜色
    
    if (dataProvider.count == 0)
        return;
    FamilyModel *item = dataProvider[0];
    titleLab.text = [NSString stringWithFormat:@"%@的健康数据",item.oldname];
}

/**
 *  获取绑定的家属
 */
-(void)getDataProvider
{
    [SharedAppUtil defaultCommonUtil].needRefleshMonitor = NO;
    dataProvider = [[NSMutableArray alloc] init];
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    
    [CommonRemoteHelper RemoteWithUrl:URL_Relation parameters: @{@"oldid" : [SharedAppUtil defaultCommonUtil].userVO.old_id,
                                                                 @"client" : @"ios",
                                                                 @"key":[SharedAppUtil defaultCommonUtil].userVO.key}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         [SharedAppUtil defaultCommonUtil].needRefleshMonitor = YES;
                                         //                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         //                                         [alertView show];
                                         [self initWithPlaceString:@"您还没有绑定的家属呐"];
                                     }
                                     else
                                     {
                                         FamilyTotal *result = [FamilyTotal objectWithKeyValues:dict];
                                         dataProvider = result.datas;
                                         [self setupScrollView];
                                         [self setupPageControl];
                                     }
                                     [SVProgressHUD dismiss];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [SVProgressHUD dismiss];
                                     [self.view endEditing:YES];
                                 }];
}

#pragma mark - 滑动tab视图代理方法
#pragma mark pageControl
/**
 *  添加UISrollView
 */
- (void)setupScrollView
{
    // 2.添加view
    for (int i = 0; i< dataProvider.count ; i++)
    {
        HealthPageViewController *page = [[HealthPageViewController alloc] init];
        page.view.frame = CGRectMake(MTScreenW *i, 0, MTScreenW, MTScreenH);
        page.familyVO = dataProvider[i];
        [self addChildViewController:page];
        [self.scrollView  addSubview:page.view];
    }
    
    // 3.设置其他属性
    self.scrollView .contentSize = CGSizeMake(dataProvider.count * self.scrollView.width, 0);
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
    FamilyModel *item = dataProvider[intPage];
    titleLab.text = [NSString stringWithFormat:@"%@的健康数据",item.oldname];
}

-(void)addHandler:(id)sender
{
    AddMemberViewController *addView = [[AddMemberViewController alloc] init];
    [self.navigationController pushViewController:addView animated:YES];
}

@end
