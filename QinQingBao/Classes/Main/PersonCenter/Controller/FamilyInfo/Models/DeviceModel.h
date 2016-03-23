//
//  DeviceModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/3/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
//"deviceid": "1",
//"device_m_m_id": "1",
//"device_code": "626010130000208",
//"device_name": "手表",
//"device_detial": "HVIT-HM11",
//"mem_id_1": "4151",
//"mem_id_2": "4151",
//"spe_name": "大爷"
@interface DeviceModel : NSObject
@property (nonatomic, copy) NSString *ud_id;
@property (nonatomic, copy) NSString *ud_name;
@property (nonatomic, copy) NSString *ud_phone;
@property (nonatomic, copy) NSString *ud_identity;
@property (nonatomic, copy) NSString *ud_mem_id;
@property (nonatomic, copy) NSString *member_id;
@property (nonatomic, strong) NSMutableArray *device;
@property (nonatomic, strong) NSMutableArray *ud_sos;
@property (nonatomic, copy) NSString *rel_name;

@end
