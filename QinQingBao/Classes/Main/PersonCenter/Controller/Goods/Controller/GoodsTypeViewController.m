//
//  GoodsTypeViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/20.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "GoodsTypeViewController.h"
#import "MTSlipPageViewController.h"

@interface GoodsTypeViewController ()<MTSwitchViewDelegate>

@end

@implementation GoodsTypeViewController

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
    self.vc0 = [[GoodsViewController alloc] init];
    self.vc0.title = @"全部";
    
    self.vc1 = [[GoodsViewController alloc] init];
    self.vc1.title = @"待付款";
    
    self.vc2 = [[GoodsViewController alloc] init];
    self.vc2.title = @"待发货";
    
    self.vc3 = [[GoodsViewController alloc] init];
    self.vc3.title = @"待收货";
    
    self.vc4 = [[GoodsViewController alloc] init];
    self.vc4.title = @"待评价";
    
    self.vc5 = [[RefundGoodsListController alloc] init];
    self.vc5.title = @"售后/取消";
    
    MTSlipPageViewController *view = [[MTSlipPageViewController alloc] initWithFrame:CGRectMake(0, 64, self.view.width, MTScreenH + 49)];
    view.delegate = self;
    view.viewArr = [NSMutableArray arrayWithObjects:self.vc0,self.vc1,self.vc2,self.vc3,self.vc4,self.vc5, nil];
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
    GoodsViewController *vc = nil;
    if (number != 5) {
        if (number == 0) {
            vc = self.vc0;
        }else if (number == 1) {
            vc = self.vc1;
        } else if (number == 2) {
            vc = self.vc2;
        } else if (number == 3) {
            vc = self.vc3;
        } else if (number == 4) {
            vc = self.vc4;
        }
        vc.nav = self.navigationController;
        [vc viewDidCurrentView];
    }else if (number == 5) {
        self.vc5.nav = self.navigationController;
        [self.vc5 loadFirstPageRefundListData];
    }
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title =   @"我的商品";
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
