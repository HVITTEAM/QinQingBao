//
//  OrderTableViewController.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/15.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "OrderTableViewController.h"

//static float topHeight = 190;
static float cellHeight = 80;
static float cellWidth = 66;

@interface OrderTableViewController ()

@end

@implementation OrderTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initNavigation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.backgroundColor = HMGlobalBg;
    [self.view addSubview:self.scrollView];
    
    [self initView];
    
    self.vc1 = [[QCListViewController alloc] init];
    self.vc1.title = @"全部";
    
    self.vc2 = [[QCListViewController alloc] init];
    self.vc2.title = @"已下单";
    
    self.vc3 = [[QCListViewController alloc] init];
    self.vc3.title = @"待处理";
    
    self.vc4 = [[QCListViewController alloc] init];
    self.vc4.title = @"派单中";
    
    self.vc5 = [[QCListViewController alloc] init];
    self.vc5.title = @"待确认";
    
    self.vc6 = [[QCListViewController alloc] init];
    self.vc6.title = @"待评价";
    
    [self.slideSwitchView buildUI];
}

#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    return 6;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return self.vc1;
    } else if (number == 1) {
        return self.vc2;
    } else if (number == 2) {
        return self.vc3;
    } else if (number == 3) {
        return self.vc4;
    } else if (number == 4) {
        return self.vc5;
    } else if (number == 5) {
        return self.vc6;
    } else {
        return nil;
    }
}

//- (void)slideSwitchView:(QCSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
//{
//    QCViewController *drawerController = (QCViewController *)self.navigationController.mm_drawerController;
//    [drawerController panGestureCallback:panParam];
//}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
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
    } else if (number == 5) {
        vc = self.vc6;
    }
    vc.nav = self.navigationController;
    [vc viewDidCurrentView];
}


-(void)initView
{
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.slideSwitchView = [[QCSlideSwitchView alloc] initWithFrame:CGRectMake(0,0, self.view.width, self.view.height  - cellWidth)];
    self.slideSwitchView.slideSwitchViewDelegate = self;
    [self.scrollView addSubview:self.slideSwitchView];
    
    
    self.slideSwitchView.tabItemNormalColor = [QCSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [QCSlideSwitchView colorFromHexRGB:@"1e90ff"];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
}



/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title =  self.viewOwer.length == 0 ?  @"我的订单" : [NSString stringWithFormat:@"%@的订单",self.viewOwer];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"default_common_navibar_prev_normal.png"
                                                                 highImageName:@"default_common_navibar_prev_highlighted.png"
                                                                        target:self action:@selector(back)];
    
    self.navigationController.navigationBar.barTintColor = HMColor(29 , 164, 232);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

#pragma mark - Table view data source
-(void)back
{
    self.viewOwer.length == 0 ? [self.navigationController popViewControllerAnimated:YES] : [self dismissViewControllerAnimated:YES completion:nil];
}

@end
