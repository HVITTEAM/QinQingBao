//
//  HabitViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/10/28.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "HMCommonViewController.h"
#import "HabitinfoModel.h"

@interface HabitViewController : HMCommonViewController

@property (nonatomic, retain)  HabitinfoModel *habitVO;

@property (nonatomic, assign) UINavigationController *nav;

@end
