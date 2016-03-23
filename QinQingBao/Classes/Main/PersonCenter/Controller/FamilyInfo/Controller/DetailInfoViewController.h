//
//  DetailInfoViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/15.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMCommonViewController.h"
#import "FamilyModel.h"

#import "DeviceModel.h"
@interface DetailInfoViewController : HMCommonViewController

@property (nonatomic, retain) DeviceModel *itemInfo;
@end
