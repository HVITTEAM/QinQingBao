//
//  HealthMonitorViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/13.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//


static float cellHeight = 80;
static float cellWidth = 66;


#import "HealthMonitorViewController.h"

@interface HealthMonitorViewController ()

@end

@implementation HealthMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.backgroundColor = HMGlobalBg;
    [self.view addSubview:self.scrollView];
    
    [self initView];
    
    self.vc1 = [[HealthPageViewController alloc] init];
    self.vc1.title = @"王大妈";
    
    self.vc2 = [[HealthPageViewController alloc] init];
    self.vc2.title = @"王大妈";
    
    self.vc3 = [[HealthPageViewController alloc] init];
    self.vc3.title = @"王大妈";
    
    self.vc4 = [[HealthPageViewController alloc] init];
    self.vc4.title = @"王大妈";
    
    self.vc5 = [[HealthPageViewController alloc] init];
    self.vc5.title = @"王大妈";
    
    self.vc6 = [[HealthPageViewController alloc] init];
    self.vc6.title = @"王大妈";
    
    self.vc7 = [[HealthPageViewController alloc] init];
    self.vc7.title = @"王大妈";
    
    self.vc8 = [[HealthPageViewController alloc] init];
    self.vc8.title = @"王大妈";

    
    [self.slideSwitchView buildUI];
}

#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    return 8;
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
    } else if (number == 6) {
        return self.vc7;
    } else if (number == 7) {
        return self.vc8;
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
    HealthPageViewController *vc = nil;
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
    }else if (number == 6) {
         vc = self.vc7;
    }else if (number == 7) {
    vc = self.vc8;
}

    vc.nav = self.navigationController;
//    [vc viewDidCurrentView];
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
    self.title = @"健康监护";
}

@end
