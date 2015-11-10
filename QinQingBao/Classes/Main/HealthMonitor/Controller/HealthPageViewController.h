//
//  HealthPageViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/8/13.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HeartCell.h"
#import "BloodPressureCell.h"
#import "LocationCell.h"
#import "HeartbeatCell.h"
#import "FamilyModel.h"

@interface HealthPageViewController : UITableViewController

@property (nonatomic, assign) UINavigationController *nav;

@property (nonatomic, retain) FamilyModel *familyVO;
@end
