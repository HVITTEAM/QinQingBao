//
//  AccountViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/26.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "AccountViewController.h"



@interface AccountViewController ()
{
     CouponsViewController *vc1;
     BankCardViewController *vc2;
}

@end

@implementation AccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    vc1 = [[CouponsViewController alloc] init];
    vc1.title = @"优惠券";
    
    vc2 = [[BankCardViewController alloc] init];
    vc2.title = @"银行卡";
    
    MTSlipPageViewController *view = [[MTSlipPageViewController alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.height + [UIApplication sharedApplication].statusBarFrame.size.height, self.view.width, self.view.height)];
    view.viewArr = [NSMutableArray arrayWithObjects:vc1,vc2, nil];
    [self.view addSubview:view];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = [UIColor whiteColor];
//    [button setFrame:CGRectMake(0,66,MTScreenW/2, 44)];
//    [button setTitle:@"购物券" forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:13];
//    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
//    [self.view addSubview:button];
}

@end
