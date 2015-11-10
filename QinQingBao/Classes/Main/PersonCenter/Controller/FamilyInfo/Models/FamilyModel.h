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


@property (nonatomic, copy) NSString *rid;
@property (nonatomic, copy) NSString *oid;
@property (nonatomic, copy) NSString *oldname;
@property (nonatomic, copy) NSString *relation;
@property (nonatomic, copy) NSString *oldphone;
@property (nonatomic, copy) NSString *member_areaid;
@property (nonatomic, copy) NSString *member_sex;
@property (nonatomic, copy) NSString *member_birthday;
@property (nonatomic, copy) NSString *imei_watch;
@property (nonatomic, copy) NSString *oldlon;
@property (nonatomic, copy) NSString *oldlat;
@property (nonatomic, copy) NSString *totalname;




@end
