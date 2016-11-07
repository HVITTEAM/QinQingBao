//
//  MyAccountViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MyAccountViewController.h"
#import "BalanceViewController.h"
#import "MTCouponsViewController.h"

@interface MyAccountViewController ()

@end

@implementation MyAccountViewController

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self setupGroups];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"我的账户";
    self.view.backgroundColor = HMGlobalBg;
}

# pragma  mark 设置数据源
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    //每次刷新数据源的时候需要将数据源清空
    [self.groups removeAllObjects];
    
    //重置数据源
    [self setupGroup0];
    
    //刷新表格
    [self.tableView reloadData];
}

- (void)setupGroup0
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
 
    // 设置组的所有行数据
    HMCommonArrowItem*item0 = [HMCommonArrowItem itemWithTitle:@"余额" icon:@"yue.png"];
    item0.destVcClass = [BalanceViewController class];

    HMCommonArrowItem *item1 = [HMCommonArrowItem itemWithTitle:@"代金券" icon:@"xiaofeiquan.png"];
    item1.destVcClass = [MTCouponsViewController class];
    
    HMCommonArrowItem *item2 = [HMCommonArrowItem itemWithTitle:@"积分" icon:@"jifen.png"];
    item2.operation = ^{
        [NoticeHelper AlertShow:@"尚未开通" view:nil];
    };
    
    group.items = @[item0,item1,item2];
}

@end
