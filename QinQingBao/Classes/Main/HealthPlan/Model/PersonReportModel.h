//
//  PersonReportModel.h
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonReportModel : NSObject
@property(nonatomic,copy)NSString *wr_id;

@property(nonatomic,copy)NSString *risk_level;

@property(nonatomic,copy)NSArray *entry_voice;

@property(nonatomic,copy)NSString *wp_status;

@property(nonatomic,copy)NSString *iname;

@property(nonatomic,copy)NSString *wp_create_time;

@property(nonatomic,copy)NSString *wp_final_report;

@property(nonatomic,copy)NSString *iteminfo_id;

@property(nonatomic,copy)NSString *examreport_url;
@end
