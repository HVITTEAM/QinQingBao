//
//  TimeLineModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/5/24.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeLineModel : NSObject
@property (nonatomic, retain) NSString *work_add_time;//提出申请退款时间
@property (nonatomic, retain) NSString *buyer_message;
@property (nonatomic, retain) NSString *work_seller_time;//卖家处理时间
@property (nonatomic, retain) NSString *seller_message;//管理员处理时间
@property (nonatomic, retain) NSString *work_admin_time;
@property (nonatomic, retain) NSString *admin_message;
@property (nonatomic, retain) NSString *wctime; //提交订单
@property (nonatomic, retain) NSString *pay_time; //支付成功
@property (nonatomic, retain) NSString *wjdtime;//服务开始
@property (nonatomic, retain) NSString *wjstime;//服务完成
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *pay_staus;

@end
