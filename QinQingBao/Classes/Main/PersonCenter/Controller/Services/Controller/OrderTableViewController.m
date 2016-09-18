//
//  OrderTableViewController.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/15.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "OrderTableViewController.h"
#import "MTSlipPageViewController.h"

@interface OrderTableViewController ()<MTSwitchViewDelegate>
{
    NSMutableArray *dataProvider;
    
    QCListViewController *selectedView;
}

@end

@implementation OrderTableViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    
    self.vc1 = [[QCListViewController alloc] init];
    self.vc1.title = @"全部";
    
    self.vc2 = [[QCListViewController alloc] init];
    self.vc2.title = @"待付款";
    
    self.vc3 = [[QCListViewController alloc] init];
    self.vc3.title = @"待服务";
    
    self.vc4 = [[QCListViewController alloc] init];
    self.vc4.title = @"待评价";
    
    self.vc5 = [[QCListViewController alloc] init];
    self.vc5.title = @"待退款";
    
    MTSlipPageViewController *view = [[MTSlipPageViewController alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.height + [UIApplication sharedApplication].statusBarFrame.size.height, self.view.width, MTScreenH)];
    view.delegate = self;
    view.viewArr = [NSMutableArray arrayWithObjects:self.vc1,self.vc2,self.vc3,self.vc4, self.vc5,nil];
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
    QCListViewController *vc = nil;
    if (number == 0) {
        vc = self.vc1;
    } else if (number == 1) {
        vc = self.vc2;
    } else if (number == 2) {
        vc = self.vc3;
    } else if (number == 3) {
        vc = self.vc4;
    } else if (number == 4) {
        vc = self.vc5;
    }
    
    vc.nav = self.navigationController;
    vc.noneResultHandler = ^(void)
    {
        [self.view showNonedataTooltip];
    };
    [vc viewDidCurrentView];
    
    selectedView = (QCListViewController*)view;
}

-(void)refleshData
{
    [selectedView viewDidCurrentView];
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
