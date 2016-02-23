//
//  DeviceModel.h
//  QinQingBao
//
//  Created by shi on 16/2/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfoModel : NSObject

@property (nonatomic, assign) NSString *deid;                //设备表键值

@property (nonatomic, assign) NSString *de_mem_id;           //用户memberid

@property (nonatomic, copy) NSString *device_code;           //设备imei

@property (nonatomic, copy) NSString *device_name;           //设备名称

@property (nonatomic, copy) NSString *detail;                //设备型号

@end
