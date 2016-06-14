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
#import "LoginViewController.h"

#import "DeviceModel.h"
#import "HealthPlaceHolderView.h"

@interface HealthMonitorViewController ()

@property (nonatomic, retain) UIScrollView *scrollView;

@end

@implementation HealthMonitorViewController
{
    UIPageControl *pageControl;
    UILabel *titleLab;
    NSMutableArray *dataProvider;
    
    HealthPlaceHolderView *healthPlace;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self getDataProvider];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
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
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 30)];
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    [self.navigationController.navigationBar addSubview:titleLab];
    
    if (dataProvider.count > 1)
        [self.navigationController.navigationBar addSubview:pageControl];
    
    // 2.设置圆点的颜色
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor]; // 当前页的小圆点颜色
    pageControl.pageIndicatorTintColor = HMColor(189, 189, 189); // 非当前页的小圆点颜色
    
    if (dataProvider.count == 0)
        return;
    DeviceModel *item = dataProvider[0];
    titleLab.text = item.rel_name;
}

/**
 *  获取绑定的设备
 */
-(void)getDataProvider
{
    if ([SharedAppUtil defaultCommonUtil].userVO == nil)
        return;
    [SharedAppUtil defaultCommonUtil].needRefleshMonitor = NO;
    dataProvider = [[NSMutableArray alloc] init];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [CommonRemoteHelper RemoteWithUrl:URL_get_user_devide parameters: @{@"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                                                                        @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                        @"client" : @"ios"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         if ([codeNum integerValue] == 17001)
                                         {
                                             [self showPlaceHolderView];
                                             [SharedAppUtil defaultCommonUtil].needRefleshMonitor = YES;
                                         }
                                         else
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                         }
                                         [dataProvider removeAllObjects];
                                     }
                                     else
                                     {
                                         dataProvider = [[DeviceModel objectArrayWithKeyValuesArray:[dict objectForKey:@"datas"]] mutableCopy];
                                         [self setupScrollView];
                                         [self setupPageControl];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                     [self.view endEditing:YES];
                                 }];
}

/**
 *  将自己添加到自己的家属列表里
 */
-(void)addSelfToFamily
{
    FamilyModel *fvo = [[FamilyModel alloc] init];
    fvo.member_id = [SharedAppUtil defaultCommonUtil].userVO.member_id;
    fvo.relation = @"自己";
    
    if (!dataProvider)
        dataProvider = [[NSMutableArray alloc] init];
    [dataProvider addObject:fvo];
    
    [self setupScrollView];
    [self setupPageControl];
}

#pragma mark - 滑动tab视图代理方法
#pragma mark pageControl
/**
 *  添加UISrollView
 */
- (void)setupScrollView
{
    if (dataProvider.count == 0)
        return [self showPlaceHolderView];
    else if (healthPlace)
    {
        self.navigationItem.title = @"";
        [healthPlace removeFromSuperview];
    }
    
    if (!self.scrollView)
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH)];
    [self.scrollView setContentSize:CGSizeMake(MTScreenW, MTScreenH)];
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.backgroundColor = HMGlobalBg;
    [self.view addSubview:self.scrollView];

    // 2.添加view
    for (int i = 0; i< dataProvider.count ; i++)
    {
        HealthPageViewController *page = [[HealthPageViewController alloc] init];
        page.view.frame = CGRectMake(MTScreenW *i, 0, MTScreenW, MTScreenH - 114);
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
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addHandler:)];
}

#pragma mark None UI
/**
 * 显示空数据界面
 **/
-(void)showPlaceHolderView
{
    healthPlace = [[[NSBundle mainBundle] loadNibNamed:@"HealthPlaceHolderView" owner:self options:nil] objectAtIndex:0];
    __weak __typeof(self)weakSelf = self;
    healthPlace.buttonClick = ^(UIButton *btn){
        [weakSelf addHandler:btn];
    };
    healthPlace.frame = CGRectMake(0, 0, MTScreenW, MTScreenH);
    //移除之前所显示的UI
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;
    [pageControl removeFromSuperview];
    pageControl = nil;
    [titleLab removeFromSuperview];
    titleLab = nil;
    
    self.navigationItem.title = @"监护";
    [self.view addSubview:healthPlace];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat doublePage = scrollView.contentOffset.x / scrollView.width;
    int intPage = (int)(doublePage + 0.5);
    // 设置页码
    pageControl.currentPage = intPage;
    DeviceModel *item = dataProvider[intPage];
    titleLab.text = item.rel_name;
}

/**
 *  添加亲友
 *
 *  @param sender
 */
-(void)addHandler:(id)sender
{
    AddMemberViewController *addView = [[AddMemberViewController alloc] init];
    addView.hidesBottomBarWhenPushed = YES;
    addView.fromHealth = YES;
    [self.navigationController pushViewController:addView animated:YES];
}

@end
