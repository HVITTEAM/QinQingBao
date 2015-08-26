//
//  AccountViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/26.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "AccountViewController.h"



@interface AccountViewController ()

@end

@implementation AccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.vc1 = [[CouponsViewController alloc] init];
    self.vc1.title = @"优惠券";
    
    self.vc2 = [[BankCardViewController alloc] init];
    self.vc2.title = @"银行卡";
    
    MTSlipPageViewController *view = [[MTSlipPageViewController alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.height + [UIApplication sharedApplication].statusBarFrame.size.height, self.view.width, self.view.height)];
    view.viewArr = [NSMutableArray arrayWithObjects:self.vc1,self.vc2, nil];
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
