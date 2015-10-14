//
//  HealthDataModel.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/24.
//  Copyright © 2015年 董徐维. All rights reserved.
//


//"mid": "120",
//"oid": "1",
//"deviceid": "1",
//"type": "1",
//"pulse": "90",
//"pulse_status": "1",
//"blood_pressure_shrink": "110",
//"blood_pressure_diastolic": "120",
//"blood_pressure_status": "1",
//"blood_sugar": "4",
//"blood_sugar_status": "1",
//"blood_oxygen": "90",
//"blood_oxygen_status": "1",
//"position_monitoring_lat": null,
//"position_monitoring_lon": null,
//"position_monitoring_status": "1",
//"collectiontime": "2015-09-16 15:38:06",
//"uploadtime": "2015-09-16 15:38:08"


//"pulse": 脉搏,
//"blood_pressure_shrink": 收缩压,
//"blood_pressure_diastolic": 舒张压,
//"blood_sugar": 血糖,
//"blood_oxygen": 血氧,
//"position_monitoring_lat": 位置经度,
//"position_monitoring_lon": 位置纬度,
//"collectiontime": 收集时间
//"uploadtime": 上传时间
#import <Foundation/Foundation.h>

@interface HealthDataModel : NSObject

@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *oid;
@property (nonatomic, copy) NSString *deviceid;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *pulse;
@property (nonatomic, copy) NSString *pulse_status;
@property (nonatomic, copy) NSString *blood_pressure_shrink;
@property (nonatomic, copy) NSString *blood_pressure_diastolic;
@property (nonatomic, copy) NSString *blood_pressure_status;
@property (nonatomic, copy) NSString *blood_sugar;
@property (nonatomic, copy) NSString *blood_sugar_status;
@property (nonatomic, copy) NSString *blood_oxygen;
@property (nonatomic, copy) NSString *blood_oxygen_status;
@property (nonatomic, copy) NSString *position_monitoring_lat;
@property (nonatomic, copy) NSString *position_monitoring_lon;
@property (nonatomic, copy) NSString *position_monitoring_status;
@property (nonatomic, copy) NSString *collectiontime;
@property (nonatomic, copy) NSString *uploadtime;



@end
