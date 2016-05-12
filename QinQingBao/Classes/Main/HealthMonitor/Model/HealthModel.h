//
//  HealthModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/3/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
//"gps_time": "2016-03-17 17:32:30",
//"longitude": "113.57407",
//"latitude": "22.403137",
//"address": "（精）广东省珠海市香洲区中珠南路(珠海宏锋风能科技有限责任公司东北682米)",
//"heart_time": "2016-03-08 14:53:38",
//"heartrate_max": "59",
//"heartrate_min": "59",
//"heartrate_avg": "59",
//"bloodglucose": null,
//"boolg_time": null,
//"systolic": "124",
//"diastolic": "75",
//"heartrate": "76",
//"bloodp_time": "2016-03-08 15:38:35",
//"ect_time": "2016-03-08 14:44:14",
//"ect_img": "ecg/626010110167932img.jpeg",
//"heartrate_report": null,
//"gps_code": "626010110167932",
//"ect_code": "626010110167932",
//"heart_code": "626010110167932",
//"bloodglucose_code": null,
//"bloodpressure_code": "626010110167932",
//"gps_name": "智能手表",
//"ect_name": "智能手表",
//"heart_name": "智能手表",
//"bloodglucose_name": null,
//"bloodpressure_name": "智能手表"
@interface HealthModel : NSObject

@property (nonatomic, copy) NSString *gps_time;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *heart_time;
@property (nonatomic, copy) NSString *heartrate_max;
@property (nonatomic, copy) NSString *heartrate_min;
@property (nonatomic, copy) NSString *heartrate_avg;
@property (nonatomic, copy) NSString *bloodsugar;
@property (nonatomic, copy) NSString *boolg_time;
@property (nonatomic, copy) NSString *systolic;
@property (nonatomic, copy) NSString *diastolic;
@property (nonatomic, copy) NSString *heartrate;
@property (nonatomic, copy) NSString *bloodp_time;
@property (nonatomic, copy) NSString *ect_time;
@property (nonatomic, copy) NSString *ect_img;
@property (nonatomic, copy) NSString *heartrate_report;
@property (nonatomic, copy) NSString *gps_code;
@property (nonatomic, copy) NSString *ect_code;
@property (nonatomic, copy) NSString *heart_code;
@property (nonatomic, copy) NSString *bloodsugar_time;
@property (nonatomic, copy) NSString *gps_name;
@property (nonatomic, copy) NSString *ect_name;
@property (nonatomic, copy) NSString *heart_name;
@property (nonatomic, copy) NSString *bloodglucose_name;
@property (nonatomic, copy) NSString *bloodpressure_name;
//@property (nonatomic, copy) NSString *gps_time;


@end
