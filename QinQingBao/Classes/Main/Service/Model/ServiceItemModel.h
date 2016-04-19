//
//  ServiceItemModel.h
//  QinQingBao
//
//  Created by 董徐维 on 15/10/30.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

//"iid": "1",
//"orgid": "1",               服务商编号
//"tid": "6",                 类型编号
//"price": "0.01",            价格
//"icontent": "送药",         服务内容
//"servicetime": "",          服务时间
//"servicerange": "",         服务范围
//"dvcode": "330102001051",   服务商地址
//"orgaddress": "详细地址",   服务商地址详细
//"reservation": "0",         预定时间
//"status": "1",              服务的状态
//"item_url": "images\/items\/default.png",  服务的图片
//"orgname": "商2测试服务商2测试服务商2",      服务商的名字
//"orglon": "120.94847400",    服务商的经纬度
//"orglat": "30.52847700",
//"tname": "家政服务",        服务分类 型
//"url": "images\/icons\/default.png",  服务分类的图片
//"sumsell": "23",           总销量
//"sumgrad": "45",           总评分
//"sumdis": "9",             评论条数
//"orgphone": "86035977"     服务商电话
@interface ServiceItemModel : NSObject
/**代金券编号**/
@property (nonatomic, copy) NSString *iid;
/**服务商编号 **/
@property (nonatomic, copy) NSString *orgid;
/**类型编号**/
@property (nonatomic, copy) NSString *tid;
/**价格**/
@property (nonatomic, copy) NSString *price;
/**服务内容**/
@property (nonatomic, copy) NSString *icontent;
/**服务时间**/
@property (nonatomic, copy) NSString *servicetime;
/**服务范围 **/
@property (nonatomic, copy) NSString *servicerange;
/**服务商地址**/
@property (nonatomic, copy) NSString *dvcode;
/**服务商地址详细**/
@property (nonatomic, copy) NSString *orgaddress;
/**预定时间**/
@property (nonatomic, copy) NSString *reservation;
/**服务的状态**/
@property (nonatomic, copy) NSString *status;
/**服务额图片 **/
@property (nonatomic, copy) NSString *item_url;
/** 服务商的名字**/
@property (nonatomic, copy) NSString *orgname;
/**服务商的经纬度**/
@property (nonatomic, copy) NSString *orglon;
/****/
@property (nonatomic, copy) NSString *orglat;
/**服务分类 型**/
@property (nonatomic, copy) NSString *tname;
/**服务分类的图片) **/
@property (nonatomic, copy) NSString *url;
/**代总销量**/
@property (nonatomic, copy) NSString *sumsell;
/**总评分**/
@property (nonatomic, copy) NSString *sumgrad;
/**评论条数**/
@property (nonatomic, copy) NSString *sumdis;
/**服务商电话**/
@property (nonatomic, copy) NSString *orgphone;
/**自己电话**/
@property (nonatomic, copy) NSString *orgtelnum;
/**服务商距离**/
@property (nonatomic, copy) NSString *distance;
/**消费提醒**/
@property (nonatomic, copy) NSString *remakr;
/**地址**/
@property (nonatomic, copy) NSString *totalname;
/**参考价格**/
@property (nonatomic, copy) NSString *guide_price;
/**店铺说明**/
@property (nonatomic, copy) NSString *store_description;

/**服务商图片 **/
@property (nonatomic, copy) NSString *orglogo;



@end


