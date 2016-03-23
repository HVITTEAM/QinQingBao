//
//  DevicesInforViewController.h
//  QinQingBao
//
//  Created by shi on 16/2/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HMCommonViewController.h"
@class DeviceModel;


@interface DevicesInforViewController : HMCommonViewController

@property (strong,nonatomic) DeviceModel *selectedFamilyMember;

@property (strong,nonatomic) NSMutableArray *devicesArray;            //设备数据

@end
