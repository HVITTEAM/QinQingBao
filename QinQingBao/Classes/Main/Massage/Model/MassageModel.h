//
//  MassageModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/4/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MassageModel : NSObject

@property (nonatomic, retain) NSMutableArray *orgids;
@property (nonatomic, copy) NSString *iid;
@property (nonatomic, copy) NSString *iname;
@property (nonatomic, copy) NSString *iid_num;
@property (nonatomic, copy) NSString *item_url;
@property (nonatomic, copy) NSString *price_min;
@property (nonatomic, copy) NSString *price_max;
@property (nonatomic, copy) NSString *price_time_min;
@property (nonatomic, copy) NSString *price_time_max;
@property (nonatomic, copy) NSString *sell;


@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *price_time;
@property (nonatomic, copy) NSString *effect;
@property (nonatomic, copy) NSString *process;
@property (nonatomic, copy) NSString *appropriate_population;
@property (nonatomic, copy) NSString *medicines;
@property (nonatomic, copy) NSString *wgrade;
@property (nonatomic, retain) NSArray *introduce_url;



@end
