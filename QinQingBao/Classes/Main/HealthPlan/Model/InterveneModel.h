//
//  InterveneModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/8/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterveneModel : NSObject
@property (nonatomic, copy) NSString *wid;
@property (nonatomic, copy) NSString *advice_diet;
@property (nonatomic, copy) NSString *advice_sport;
@property (nonatomic, copy) NSString *advice_others;
@property (nonatomic, copy) NSString *advice_report;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *memid;
@property (nonatomic, copy) NSString *general_analysis;
@property (nonatomic, copy) NSString *short_goal;
@property (nonatomic, copy) NSString *long_goal;
@property (nonatomic, copy) NSString *naturopathy;
@property (nonatomic, copy) NSString *nutrient_plan;
@property (nonatomic, copy) NSString *nutrient_goods;
@property (nonatomic, copy) NSString *wc_sex;
@property (nonatomic, copy) NSString *wc_birthday;
@property (nonatomic, copy) NSString *wc_height;
@property (nonatomic, copy) NSString *wc_weight;
@property (nonatomic, copy) NSString *wc_monthday;
@property (nonatomic, copy) NSString *wc_sickhistory;
@property (nonatomic, copy) NSString *wc_medication;
@property (nonatomic, copy) NSString *item_url_big;
@property (nonatomic, copy) NSString *wname;

@property (nonatomic, copy) NSString *wtelnum;
@property (nonatomic, copy) NSString *waddress;
@property (nonatomic, copy) NSString *totalname;

@property (nonatomic, strong) NSArray *goodsinfos;

//检测报告
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *filesize;
@property (nonatomic, copy) NSString *iname;
@property (nonatomic, copy) NSString *item_url;

@end
