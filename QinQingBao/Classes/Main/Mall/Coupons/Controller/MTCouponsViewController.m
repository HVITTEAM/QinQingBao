//
//  MTCouponsViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MTCouponsViewController.h"
#import "MTSlipPageViewController.h"


@interface MTCouponsViewController ()<MTSwitchViewDelegate>
{
    NSMutableArray *dataProvider;
}

@end

@implementation MTCouponsViewController


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
    
    self.vc1 = [[CouponsViewController alloc] init];
    self.vc1.title = @"全部";
    
    self.vc2 = [[CouponsViewController alloc] init];
    self.vc2.title = @"已使用";
    
    self.vc3 = [[CouponsViewController alloc] init];
    self.vc3.title = @"未使用";
    
    MTSlipPageViewController *view = [[MTSlipPageViewController alloc] initWithFrame:CGRectMake(0, 64, self.view.width, MTScreenH + 49)];
    view.delegate = self;
    view.viewArr = [NSMutableArray arrayWithObjects:self.vc1,self.vc2,self.vc3, nil];
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
    CouponsViewController *vc = nil;
    CouponsViewController *usevc;
    if (number == 0)
    {
        vc = self.vc1;
        vc.nav = self.navigationController;
        
        [vc viewDidCurrentView];
    }
    else if (number == 1)
    {
        vc = self.vc2;
        vc.nav = self.navigationController;
        [vc viewDidCurrentView];
    }
    else if (number == 2)
    {
        usevc = self.vc3;
        usevc.nav = self.navigationController;
        [usevc viewDidCurrentView];
    }
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title =   @"优惠券";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Table view data source
-(void)back
{
    self.viewOwer.length == 0 ? [self.navigationController popViewControllerAnimated:YES] : [self dismissViewControllerAnimated:YES completion:nil];
}


@end
