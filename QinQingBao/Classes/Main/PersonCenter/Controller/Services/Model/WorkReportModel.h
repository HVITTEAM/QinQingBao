//
//  WorkReportModel.h
//  QinQingBao
//
//  Created by shi on 16/6/28.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkReportModel : NSObject

@property(nonatomic,copy)NSString *wp_wid;

@property(nonatomic,copy)NSString *wp_advice_diet;

@property(nonatomic,copy)NSString *wp_advice_sport;

@property(nonatomic,copy)NSString *wp_advice_others;

@property(nonatomic,copy)NSString *wp_email;

@property(nonatomic,copy)NSString *wp_create_time;

@property(nonatomic,copy)NSString *wp_memid;

@property(nonatomic,copy)NSArray *wp_advice_report;

@end
