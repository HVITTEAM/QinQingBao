//
//  HMCommonViewController.h
//
//  Created by apple on 14-7-21.
//  Copyright (c) 2014年 heima. All rights reserved.
//
// 颜色
#define HMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 全局背景色
#define HMGlobalBg HMColor(235, 235, 235)

// 表格选中背景色
#define HMSelectBg HMColor(220, 220, 220)

// cell的计算参数
// cell之间的间距
#define HMStatusCellMargin 10

#import <UIKit/UIKit.h>

@interface HMCommonViewController : UITableViewController
- (NSMutableArray *)groups;
@end