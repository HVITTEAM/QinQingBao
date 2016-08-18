//
//  MarketCustomInfo.h
//  QinQingBao
//
//  Created by shi on 16/8/16.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketCustomInfo : NSObject

@property(copy,nonatomic)NSString *name;

@property(copy,nonatomic)NSString *tel;

//@property(copy,nonatomic)NSString *address;

@property(copy,nonatomic)NSString *email;

@property(copy,nonatomic)NSString *sex;

@property(copy,nonatomic)NSString *birthday;

@property(copy,nonatomic)NSString *height;

@property(copy,nonatomic)NSString *weight;

@property(copy,nonatomic)NSString *womanSpecial;

@property(copy,nonatomic)NSString *caseHistory;

@property(copy,nonatomic)NSString *medicine;

@property(copy,nonatomic)NSString *dvcode;

@property(copy,nonatomic)NSString *totalname;

@property(copy,nonatomic)NSString *areainfo;


+(NSInteger)sexToNumber:(NSString *)sex;

+(NSString *)numberToSex:(NSInteger)number;

+(NSInteger)womanSpecialToNumber:(NSString *)womanSpecial;


@end
