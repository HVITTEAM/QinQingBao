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
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 50, 50);
    [right addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [right setTitle:@"关闭" forState:UIControlStateNormal];
    [right setTitleColor:HMColor(139, 198, 63) forState:UIControlStateNormal];
    UIBarButtonItem *rightBut = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBut;
}

-(void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
