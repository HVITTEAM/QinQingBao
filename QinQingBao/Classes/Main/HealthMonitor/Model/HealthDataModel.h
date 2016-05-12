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

@property (nonatomic, copy) NSString *ect_time;
@property (nonatomic, copy) NSString *heartrate;
@property (nonatomic, copy) NSString *heart_time;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *bloodp_time;
@property (nonatomic, copy) NSString *gps_time;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *bloodsugar_time;
@property (nonatomic, copy) NSString *heartrate_report;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *systolic;
@property (nonatomic, copy) NSString *diastolic;
@property (nonatomic, copy) NSString *bloodsugar;
@property (nonatomic, copy) NSString *heartrate_min;
@property (nonatomic, copy) NSString *heartrate_avg;
@property (nonatomic, copy) NSString *heartrate_max;
@property (nonatomic, copy) NSString *ect_img;
//@property (nonatomic, copy) NSString *collectiontime;
//@property (nonatomic, copy) NSString *uploadtime;



@end
