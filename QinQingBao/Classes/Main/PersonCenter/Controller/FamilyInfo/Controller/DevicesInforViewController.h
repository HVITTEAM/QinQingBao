//
//  DevicesInforViewController.h
//  QinQingBao
//
//  Created by shi on 16/2/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HMCommonViewController.h"
@class FamilyModel;


@interface DevicesInforViewController : HMCommonViewController

@property (strong,nonatomic) FamilyModel *selectedFamilyMember;

@property (strong,nonatomic) NSMutableArray *devicesArray;            //设备数据

@end
