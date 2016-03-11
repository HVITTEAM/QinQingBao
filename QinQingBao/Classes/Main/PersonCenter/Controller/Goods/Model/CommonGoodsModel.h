//
//  CommonGoodsModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/13.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CmmonOrderListTotal.h"

@interface CommonGoodsModel : NSObject
@property(nonatomic,copy)NSMutableArray *order_list;
@property(nonatomic,copy)NSMutableArray *goods_list;
@property(nonatomic,copy)NSString *add_time;
@property(nonatomic,copy)NSString *pay_sn;
@property(nonatomic,copy)NSString *pay_amount;

//订单详情需要的字段
@property(nonatomic,copy)NSString *order_id;
@property(nonatomic,copy)NSString *order_sn;
@property(nonatomic,copy)NSString *store_id;
@property(nonatomic,copy)NSString *store_name;
@property(nonatomic,copy)NSString *buyer_id;
@property(nonatomic,copy)NSString *buyer_name;
@property(nonatomic,copy)NSString *buyer_email;
@property(nonatomic,copy)NSString *payment_code;
@property(nonatomic,copy)NSString *payment_time;
@property(nonatomic,copy)NSString *finnshed_time;
@property(nonatomic,copy)NSString *goods_amount;
@property(nonatomic,copy)NSString *order_amount;
@property(nonatomic,copy)NSString *rcb_amount;
@property(nonatomic,copy)NSString *pd_amount;
@property(nonatomic,copy)NSString *shipping_fee;
@property(nonatomic,copy)NSString *evaluation_state;
@property(nonatomic,copy)NSString *order_state;
@property(nonatomic,copy)NSString *refund_state;
@property(nonatomic,copy)NSString *lock_state;
@property(nonatomic,copy)NSString *delete_state;
@property(nonatomic,copy)NSString *refund_amount;
@property(nonatomic,copy)NSString *delay_time;
@property(nonatomic,copy)NSString *order_from;
@property(nonatomic,copy)NSString *shipping_code;
@property(nonatomic,copy)NSString *state_desc;
@property(nonatomic,copy)NSString *payment_name;
@property(nonatomic,copy)NSMutableArray *extend_order_goods;
@property(nonatomic,copy)NSString *if_cancel;
@property(nonatomic,copy)NSString *if_receive;
@property(nonatomic,copy)NSString *if_lock;
@property(nonatomic,copy)NSString *if_deliver;
@end
