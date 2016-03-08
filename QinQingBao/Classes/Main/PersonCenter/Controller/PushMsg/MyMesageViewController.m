//
//  MyMesageViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/3/3.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MyMesageViewController.h"

@interface MyMesageViewController ()

@end

@implementation MyMesageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的消息";
    
    self.view.backgroundColor  = [UIColor whiteColor];
}

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


@end
