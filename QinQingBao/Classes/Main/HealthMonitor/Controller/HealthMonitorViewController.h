//
//  HealthMonitorViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/8/13.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCSlideSwitchView.h"
#import "HealthPageViewController.h"

@interface HealthMonitorViewController : UIViewController<QCSlideSwitchViewDelegate>

@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, strong) QCSlideSwitchView *slideSwitchView;

@property(nonatomic, retain) NSMutableArray *array;//创建一个数组属性 作为top菜单的数据源

@property(nonatomic, retain) NSMutableArray *dataProvider;//创建一个数组属性

@property (nonatomic, strong) HealthPageViewController *vc1;
@property (nonatomic, strong) HealthPageViewController *vc2;
@property (nonatomic, strong) HealthPageViewController *vc3;
@property (nonatomic, strong) HealthPageViewController *vc4;
@property (nonatomic, strong) HealthPageViewController *vc5;
@property (nonatomic, strong) HealthPageViewController *vc6;
@property (nonatomic, strong) HealthPageViewController *vc7;
@property (nonatomic, strong) HealthPageViewController *vc8;

@end
