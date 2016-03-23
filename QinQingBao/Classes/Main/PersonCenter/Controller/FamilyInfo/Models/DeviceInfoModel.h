//
//  DeviceModel.h
//  QinQingBao
//
//  Created by shi on 16/2/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfoModel : NSObject

@property (nonatomic, copy) NSString *deviceid;                //设备表键值

@property (nonatomic, copy) NSString *device_name;           //用户memberid

@property (nonatomic, copy) NSString *device_type;           //设备imei

@property (nonatomic, copy) NSString *device_detial;           //设备名称

@property (nonatomic, copy) NSString *device_num;                //设备型号

@property (nonatomic, copy) NSString *device_code;                //设备型号


@end
