//
//  FamilyModel.h
//  QinQingBao
//
//  Created by 董徐维 on 15/10/22.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

//"member_areaid": "330102001057",
//"totalname": "杭州市上城区清波街道柳翠井巷社区",
//"member_sex": "1",
//"member_birthday": "1444638894",
//"imei_watch": null,  手表的imei 用于确定有没有开通服务
//"oldlon": "0.000000", 地理坐标
//"oldlat": "0.000000",
//"relation": "朋友2"

@interface FamilyModel : NSObject


@property (nonatomic, copy) NSString *member_truename;
@property (nonatomic, copy) NSString *member_id;
@property (nonatomic, copy) NSString *member_areaid;
@property (nonatomic, copy) NSString *totalname;
@property (nonatomic, copy) NSString *member_sex;
@property (nonatomic, copy) NSString *member_birthday;
@property (nonatomic, copy) NSString *member_areainfo;
@property (nonatomic, copy) NSString *relation;
@property (nonatomic, copy) NSString *member_mobile;


@property (nonatomic, copy)NSString *identity;         //身份证号
@property (nonatomic, copy)NSString *re_nicename;      //亲属昵称

@end
