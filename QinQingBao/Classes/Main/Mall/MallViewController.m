//
//  MallViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/25.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "MallViewController.h"

@interface MallViewController ()

@end

@implementation MallViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initTableviewskin];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBarHidden = YES;
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"商城";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView initWithPlaceString:@"暂未开通,敬请期待！"];
}


-(void)initTableviewskin
{
    self.tableView.tableFooterView = [[UIView alloc] init];
}

@end
