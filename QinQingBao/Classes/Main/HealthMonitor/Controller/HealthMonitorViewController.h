//
//  HealthMonitorViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/8/13.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthPageViewController.h"

@interface HealthMonitorViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView *scrollView;

@property(nonatomic, retain) NSMutableArray *array;//创建一个数组属性 作为top菜单的数据源

@property(nonatomic, retain) NSMutableArray *dataProvider;//创建一个数组属性

@end
