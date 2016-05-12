//
//  SettlementViewController.m
//  QinQingBao
//
//  Created by shi on 16/5/5.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "SettlementSlideViewController.h"
#import "SettlementListViewController.h"
#import "MTSlipPageViewController.h"

@interface SettlementSlideViewController ()<MTSwitchViewDelegate>

@property(strong,nonatomic)SettlementListViewController *vc1;

@property(strong,nonatomic)SettlementListViewController *vc2;

@end

@implementation SettlementSlideViewController

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"结算";
    
    self.navigationController.navigationBar.translucent = NO;

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.vc1 = [[SettlementListViewController alloc] init];
    self.vc1.nav = self.navigationController;
    self.vc1.title = @"未结算订单";
    
    self.vc2 = [[SettlementListViewController alloc] init];
    self.vc2.nav = self.navigationController;
    self.vc2.title = @"已结算订单";
    
    MTSlipPageViewController *view = [[MTSlipPageViewController alloc] initWithFrame:self.view.bounds];
    view.delegate = self;
    view.viewArr = [NSMutableArray arrayWithObjects:self.vc1,self.vc2, nil];
    [self.view addSubview:view];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)switchView:(UIViewController *)view didselectTab:(NSUInteger)number
{
    SettlementListViewController *vc = (SettlementListViewController *)view;
    
    [vc viewDidCurrentView];
}

@end
