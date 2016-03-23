//
//  AddDeviceViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/2/17.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HMCommonViewController.h"
#import "DeviceModel.h"

@interface AddDeviceViewController : HMCommonViewController

//是否来自于新增联系人，是的话退出的时候需要弹出提示
@property (nonatomic, assign) BOOL isFromStart;

@property (strong,nonatomic) DeviceModel *selectedFamily;

@end
