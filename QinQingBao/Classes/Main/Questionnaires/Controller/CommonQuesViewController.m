//
//  CommonQuesViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/7/12.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonQuesViewController.h"

@interface CommonQuesViewController ()

@end

@implementation CommonQuesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 自定义返回按钮
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)back
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
