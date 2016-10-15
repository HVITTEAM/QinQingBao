//
//  WorkReportModel.h
//  QinQingBao
//
//  Created by shi on 16/6/28.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkReportModel : NSObject

@property(nonatomic,copy)NSString *wid;

@property(nonatomic,copy)NSString *advice_diet;

@property(nonatomic,copy)NSString *advice_sport;

@property(nonatomic,copy)NSString *advice_others;

@property(nonatomic,copy)NSString *email;

@property(nonatomic,copy)NSString *create_time;

@property(nonatomic,copy)NSString *memid;

@property(nonatomic,copy)NSArray *advice_report;

@end
