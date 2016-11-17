//
//  NewHomeViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "NewHomeViewController.h"
#import "MyMesageViewController.h"
#import "MsgAndPushViewController.h"

#import "SearchViewController.h"
#import "ReportListViewController.h"

#import "ServiceHomeViewController.h"
#import "HealthPlanController.h"

@interface NewHomeViewController ()
{
    PostsTableViewController *selectedView;
    UIButton *rightBtn;
}

@property (nonatomic, strong) PostsTableViewController *vc1;
@property (nonatomic, strong) ServiceHomeViewController *vc2;
@property (nonatomic, strong) HealthPlanController *vc3;
@end

@implementation NewHomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getAllPriletterList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initRootController];
}

/**
 *  初始化根控制器
 */
-(void)initRootController
{
    self.vc1 = [[PostsTableViewController alloc] init];
    self.vc1.parentVC = self;
    self.vc1.title = @"资讯";
    
    self.vc2 = [[ServiceHomeViewController alloc] init];
    self.vc2.parentVC = self;
    self.vc2.title = @"服务";
    
    self.vc3 = [[HealthPlanController alloc] init];
    self.vc3.parentVC = self;
    self.vc3.title = @"报告";
   
    self.viewArr = [NSMutableArray arrayWithObjects:self.vc1,self.vc2,self.vc3,nil];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //去除导航栏下方的横线
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
    //                       forBarPosition:UIBarPositionAny
    //                           barMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 19)];
    [leftBtn addTarget:self action:@selector(searchView) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 17)];
    [rightBtn addTarget:self action:@selector(showView) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"message.png"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"message.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIButton *reportBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 17)];
    [reportBtn addTarget:self action:@selector(reportListView) forControlEvents:UIControlEventTouchUpInside];
    [reportBtn setBackgroundImage:[UIImage imageNamed:@"reportList_icon"] forState:UIControlStateNormal];
    [reportBtn setBackgroundImage:[UIImage imageNamed:@"reportList_icon"] forState:UIControlStateHighlighted];
    UIBarButtonItem *reportItem = [[UIBarButtonItem alloc] initWithCustomView:reportBtn];
    self.navigationItem.rightBarButtonItems = @[rightButton,reportItem];
}

/**
 *  进入消息界面
 */
-(void)showView
{
    MsgAndPushViewController *vc = [[MsgAndPushViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  进入搜索界面
 */
-(void)searchView
{
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.type = SearchTypePosts;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  进入检测报告列表界面
 */
- (void)reportListView
{
    //判断是否登录
    if (![SharedAppUtil checkLoginStates]) {
        return;
    }
    ReportListViewController *reportListVC = [[ReportListViewController alloc] init];
    [self.navigationController pushViewController:reportListVC animated:YES];
}

#pragma mark - 网络相关
/**
 *  获取个人的所有私信
 */
- (void)getAllPriletterList
{
    //判断是否登录
    if ([SharedAppUtil defaultCommonUtil].userVO == nil)
    {
        return;
    }
    else if ([SharedAppUtil defaultCommonUtil].bbsVO == nil)
    {
        return ;
    }
    
    NSDictionary *params = @{@"key":[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key,
                             @"client":@"ios",
                             @"p": @1,
                             @"page":@"10",};
    [CommonRemoteHelper RemoteWithUrl:URL_get_allpriletter parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        id codeNum = [dict objectForKey:@"code"];
        if([codeNum integerValue] > 0)
        {
            
        }
        else
        {
            NSString *msgNum = [dict objectForKey:@"allnew"];
            NSLog(@"有%@条未读私信",msgNum);
            [rightBtn initWithBadgeValue:msgNum];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
}

@end
