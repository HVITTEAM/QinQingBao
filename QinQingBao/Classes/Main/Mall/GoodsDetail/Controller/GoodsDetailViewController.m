//
//  GoodsDetailController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "GoodsDetailViewController.h"

@interface GoodsDetailViewController ()

@end

@implementation GoodsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavgation];

}

-(void)initNavgation
{
    self.title = @"图文详情";
    self.view.backgroundColor = [UIColor whiteColor];
}


@end
