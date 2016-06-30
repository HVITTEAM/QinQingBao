//
//  OrderModel.h
//  QinQingBao
//
//  Created by 董徐维 on 15/11/25.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

//"orgname": "海盐县知音洗衣店",  服务商名字
//"icontent": "服装洗涤",         服务说明
//"wid": "90008",          订单id
//"wcode": "SN9890008",    订单号
//"sluid": null,           受理用户编号
//"pduid": null,           派单用户id
//"hfuid": null,           回访用户编号
//"tid": "2",              类型
//"iid": "26",             服务id
//"qqrid": "60",           请求服务人员编号
//"qxrid": null,           取消服务人员编号
//"dvcode": "330102003055",服务的dvcode id
//"waddress": "东大街56号",服务的详细地址
//"wlat": null,            经纬度
//"wlng": null,
//"wtime": "2015-11-18 12:59:12",服务时间
//"wremark": "",           客户留言
//"status": "0",           订单状态
//"wpdtime": null,         派单时间
//"wjdtime": null,         接单时间
//"wzxtime": null,         执行时间
//"wjstime": null,         结束时间
//"wpjtime": null,         评价时间
//"wgrade": null,          评价分数
//"wcontent": null,        工单内容
//"wmsg": null,            回访记录
//"wfrom": "",             请求来源
//"wname": "小明",          客户姓名
//"wtelnum": "1231654987", 客户联系方式
//"wsltime": null,         受理时间
//"wlevel": "2",           紧急程度 1正常 0 紧急
//"whftime": null,         回访时间
//"wqxtime": null,         工单取消申请时间
//"wqxyj": null,           工单取消服务商意见
//"wqxyy": null,           工单取消原因
//"wprice": "99.00",       价格
//"wctime": "1446441364",  工单创建时间
//"serverclassid": null,
//"returning": null,       回访内容
//"dis_con": null          评论内容
@interface OrderModel : NSObject

@property (nonatomic, retain) NSString *orgname;
@property (nonatomic, retain) NSString *icontent;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *wid;
@property (nonatomic, retain) NSString *wcode;
@property (nonatomic, retain) NSString *sluid;
@property (nonatomic, retain) NSString *pduid;
@property (nonatomic, retain) NSString *hfuid;
@property (nonatomic, retain) NSString *tid;
@property (nonatomic, retain) NSDictionary *iid;
@property (nonatomic, retain) NSString *qqrid;
@property (nonatomic, retain) NSString *qxrid;
@property (nonatomic, retain) NSString *dvcode;
@property (nonatomic, retain) NSString *waddress;
@property (nonatomic, retain) NSString *totalname;
@property (nonatomic, retain) NSString *wlat;
@property (nonatomic, retain) NSString *wlng;
@property (nonatomic, retain) NSString *wtime;
@property (nonatomic, retain) NSString *wremark;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *wpdtime;
@property (nonatomic, retain) NSString *wjdtime;
@property (nonatomic, retain) NSString *wzxtime;
@property (nonatomic, retain) NSString *wjstime;
@property (nonatomic, retain) NSString *wpjtime;
@property (nonatomic, retain) NSString *wgrade;
@property (nonatomic, retain) NSString *wcontent;
@property (nonatomic, retain) NSString *wmsg;
@property (nonatomic, retain) NSString *wfrom;
@property (nonatomic, retain) NSString *wname;
@property (nonatomic, retain) NSString *wtelnum;
@property (nonatomic, retain) NSString *wsltime;
@property (nonatomic, retain) NSString *wlevel;
@property (nonatomic, retain) NSString *whftime;
@property (nonatomic, retain) NSString *wqxtime;
@property (nonatomic, retain) NSString *wjudtime;

@property (nonatomic, retain) NSString *wqxyj;
@property (nonatomic, retain) NSString *wqxyy;
@property (nonatomic, retain) NSString *wprice;
@property (nonatomic, retain) NSString *wctime;
@property (nonatomic, retain) NSString *serverclassid;
@property (nonatomic, retain) NSString *returning;
@property (nonatomic, retain) NSString *dis_con;
@property (nonatomic, retain) NSString *pay_staus;
@property (nonatomic, retain) NSString *pay_type;
@property (nonatomic, retain) NSString *tname;

@property (nonatomic, retain) NSString *item_url;
@property (nonatomic, retain) NSString *member_id;
@property (nonatomic, retain) NSString *org_dis_con;
@property (nonatomic, retain) NSString *orgid;
@property (nonatomic, retain) NSString *orglat;
@property (nonatomic, retain) NSString *orglon;
@property (nonatomic, retain) NSString *orgphone;
@property (nonatomic, retain) NSString *orgtelnum;
@property (nonatomic, retain) NSString *remakr;
@property (nonatomic, retain) NSString *sumdis;
@property (nonatomic, retain) NSString *sumgrad;
@property (nonatomic, retain) NSString *sumsell;
@property (nonatomic, retain) NSString *voucher_id;
@property (nonatomic, retain) NSString *voucher_price;
@property (nonatomic, retain) NSString *worggrade;
@property (nonatomic, retain) NSString *worgpjtime;
@property (nonatomic, retain) NSString *pay_time;

@property (nonatomic, retain) NSString *work_add_time;

@property (nonatomic, retain) NSString *store_id;

@property (nonatomic, retain) NSString *mark_type;          //为 1 代表超生理疗 为 2 代表服务市场
@property (nonatomic, retain) NSString *mark_sell_type;     //1 特惠 2 热销

@end
