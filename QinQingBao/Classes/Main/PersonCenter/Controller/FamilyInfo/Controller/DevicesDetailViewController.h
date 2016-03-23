//
//  DevicesDetailViewController.h
//  QinQingBao
//
//  Created by shi on 16/2/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HMCommonViewController.h"

@class DeviceInfoModel;

@interface DevicesDetailViewController : HMCommonViewController

@property(strong,nonatomic)DeviceInfoModel *selectedDevice;

@end
