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


@interface NewHomeViewController ()
{
    PostsTableViewController *selectedView;
    UIButton *rightBtn;
}

@property (nonatomic, strong) PostsTableViewController *vc1;
@property (nonatomic, strong) PostsTableViewController *vc2;
@property (nonatomic, strong) PostsTableViewController *vc3;
@property (nonatomic, strong) PostsTableViewController *vc4;
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
    self.vc1.type = BBSType_1;
    self.vc1.parentVC = self;
    self.vc1.title = @"推荐";
    
    self.vc2 = [[PostsTableViewController alloc] init];
    self.vc2.type = BBSType_2;
    self.vc2.parentVC = self;
    self.vc2.title = @"关注";
    
    self.vc3 = [[PostsTableViewController alloc] init];
    self.vc3.type = BBSType_3;
    self.vc3.parentVC = self;
    self.vc3.title = @"说说";
    
    self.vc4 = [[PostsTableViewController alloc] init];
    self.vc4.type = BBSType_4;
    self.vc4.parentVC = self;
    self.vc4.title = @"资讯";
    
    self.viewArr = [NSMutableArray arrayWithObjects:self.vc1,self.vc2,self.vc3,self.vc4,nil];
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
    [self.navigationItem setRightBarButtonItem:rightButton];
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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"Msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            NSString *msgNum = [dict objectForKey:@"allnew"];
            NSLog(@"有%@条未读私信",msgNum);
            if ([msgNum integerValue] >0)
                [rightBtn initWithBadgeValue:msgNum];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
}

@end
