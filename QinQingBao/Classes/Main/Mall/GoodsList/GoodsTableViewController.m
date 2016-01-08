//
//  OrderTableViewController.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/15.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "GoodsTableViewController.h"
#import "MTSlipPageViewController.h"

@interface GoodsTableViewController ()<MTSwitchViewDelegate>
{
    NSMutableArray *dataProvider;
}

@end

@implementation GoodsTableViewController


-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initNavigation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.vc1 = [[GoodsListViewController alloc] init];
    self.vc1.title = @"综合";
    
    self.vc2 = [[GoodsListViewController alloc] init];
    self.vc2.title = @"价格";
    
    self.vc3 = [[GoodsListViewController alloc] init];
    self.vc3.title = @"销量";
    
    self.vc4 = [[GoodsListViewController alloc] init];
    self.vc4.title = @"人气";
    
    MTSlipPageViewController *view = [[MTSlipPageViewController alloc] initWithFrame:CGRectMake(0, 64, self.view.width, MTScreenH + 49)];
    view.delegate = self;
    view.viewArr = [NSMutableArray arrayWithObjects:self.vc1,self.vc2,self.vc3,self.vc4, nil];
    [self.view addSubview:view];
}


#pragma mark - 滑动tab视图代理方法

/**
 *  MT
 *
 *  @param view   <#view description#>
 *  @param number <#number description#>
 */
-(void)switchView:(UIViewController *)view didselectTab:(NSUInteger)number
{
    GoodsListViewController *vc = nil;
    if (number == 0) {
        vc = self.vc1;
    } else if (number == 1) {
        vc = self.vc2;
    } else if (number == 2) {
        vc = self.vc3;
    } else if (number == 3) {
        vc = self.vc4;
    }

    vc.nav = self.navigationController;
    vc.noneResultHandler = ^(void)
    {
        [self.view showNonedataTooltip];
    };
    [vc viewDidCurrentView];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title =  self.viewOwer.length == 0 ?  @"我的服务" : [NSString stringWithFormat:@"%@的订单",self.viewOwer];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Table view data source
-(void)back
{
    self.viewOwer.length == 0 ? [self.navigationController popViewControllerAnimated:YES] : [self dismissViewControllerAnimated:YES completion:nil];
}

@end
