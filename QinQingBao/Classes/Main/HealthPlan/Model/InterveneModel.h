//
//  InterveneModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/8/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterveneModel : NSObject
@property (nonatomic, copy) NSString *wp_wid;
@property (nonatomic, copy) NSString *wp_advice_diet;
@property (nonatomic, copy) NSString *wp_advice_sport;
@property (nonatomic, copy) NSString *wp_advice_others;
@property (nonatomic, copy) NSString *wp_advice_report;
@property (nonatomic, copy) NSString *wp_email;
@property (nonatomic, copy) NSString *wp_create_time;
@property (nonatomic, copy) NSString *wp_memid;
@property (nonatomic, copy) NSString *wp_general_analysis;
@property (nonatomic, copy) NSString *wp_short_goal;
@property (nonatomic, copy) NSString *wp_long_goal;
@property (nonatomic, copy) NSString *wp_naturopathy;
@property (nonatomic, copy) NSString *wp_nutrient_plan;
@property (nonatomic, copy) NSString *wp_nutrient_goods;
@property (nonatomic, copy) NSString *wc_sex;
@property (nonatomic, copy) NSString *wc_birthday;
@property (nonatomic, copy) NSString *wc_height;
@property (nonatomic, copy) NSString *wc_weight;
@property (nonatomic, copy) NSString *wc_monthday;
@property (nonatomic, copy) NSString *wc_sickhistory;
@property (nonatomic, copy) NSString *wc_medication;
@property (nonatomic, copy) NSString *item_url_big;

@property (nonatomic, strong) NSArray *goodsinfos;



@end
