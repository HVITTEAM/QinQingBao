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
}

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
    
    self.vc1 = [[QCListViewController alloc] init];
    self.vc1.title = @"全部订单";
    
    self.vc2 = [[QCListViewController alloc] init];
    self.vc2.title = @"待付款";
    
    self.vc3 = [[QCListViewController alloc] init];
    self.vc3.title = @"受理中";
    
    self.vc4 = [[QCListViewController alloc] init];
    self.vc4.title = @"待评价";
    
    self.vc5 = [[QCListViewController alloc] init];
    self.vc5.title = @"取消/售后";
    
    MTSlipPageViewController *view = [[MTSlipPageViewController alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.height + [UIApplication sharedApplication].statusBarFrame.size.height, self.view.width, MTScreenH + 49)];
    view.delegate = self;
    view.viewArr = [NSMutableArray arrayWithObjects:self.vc1,self.vc2,self.vc3,self.vc4,self.vc5, nil];
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
        [self showNonedataTooltip];
    };
    [vc viewDidCurrentView];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title =  self.viewOwer.length == 0 ?  @"我的订单" : [NSString stringWithFormat:@"%@的订单",self.viewOwer];
    self.view.backgroundColor = [UIColor whiteColor];
}

/**
 *  提示用户
 *
 */
- (void)showNonedataTooltip
{
    // 1.创建一个UILabel
    UILabel *label = [[UILabel alloc] init];
    label.text = @"没有新的订单数据啦";
    // 3.设置背景
    label.backgroundColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    // 4.设置frame
    label.width = self.view.width;
    label.height = 35;
    label.font = [UIFont systemFontOfSize:13];
    label.x = 0;
    label.y = MTScreenH;
    
    // 5.添加到导航控制器的view
//    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    [self.view addSubview:label];
    
    // 6.动画
    CGFloat duration = 0.75;
    [UIView animateWithDuration:duration animations:^{
        // 往下移动一个label的高度
        label.transform = CGAffineTransformMakeTranslation(0, -label.height);
    } completion:^(BOOL finished) { // 向下移动完毕
        
        // 延迟delay秒后，再执行动画
        CGFloat delay = 1.0;
        
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            // 恢复到原来的位置
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            // 删除控件
            [label removeFromSuperview];
        }];
    }];
}

#pragma mark - Table view data source
-(void)back
{
    self.viewOwer.length == 0 ? [self.navigationController popViewControllerAnimated:YES] : [self dismissViewControllerAnimated:YES completion:nil];
}

@end
