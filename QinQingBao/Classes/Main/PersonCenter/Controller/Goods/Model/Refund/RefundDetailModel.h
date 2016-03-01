//
//  RefundDetailModel.h
//  QinQingBao
//
//  Created by shi on 16/2/29.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefundDetailModel : NSObject

@property(copy,nonatomic)NSString *refund_id;

@property(copy,nonatomic)NSString *order_id;

@property(copy,nonatomic)NSString *order_sn;

@property(copy,nonatomic)NSString *refund_sn;

@property(copy,nonatomic)NSString *store_id;

@property(copy,nonatomic)NSString *store_name;

@property(copy,nonatomic)NSString *buyer_id;

@property(copy,nonatomic)NSString *buyer_name;

@property(copy,nonatomic)NSString *goods_id;

@property(copy,nonatomic)NSString *order_goods_id;

@property(copy,nonatomic)NSString *goods_name;

@property(copy,nonatomic)NSString *goods_num;

@property(copy,nonatomic)NSString *refund_amount;

@property(copy,nonatomic)NSString *goods_image;

@property(copy,nonatomic)NSString *order_goods_type;

@property(copy,nonatomic)NSString *refund_type;

@property(copy,nonatomic)NSString *seller_state;

@property(copy,nonatomic)NSString *refund_state;

@property(copy,nonatomic)NSString *return_type;

@property(copy,nonatomic)NSString *order_lock;

@property(copy,nonatomic)NSString *goods_state;

@property(copy,nonatomic)NSString *add_time;

@property(copy,nonatomic)NSString *seller_time;

@property(copy,nonatomic)NSString *admin_time;

@property(copy,nonatomic)NSString *reason_id;

@property(copy,nonatomic)NSString *reason_info;

@property(copy,nonatomic)NSString *pic_info;

@property(copy,nonatomic)NSString *buyer_message;

@property(copy,nonatomic)NSString *seller_message;

@property(copy,nonatomic)NSString *admin_message;

@property(copy,nonatomic)NSString *express_id;

@property(copy,nonatomic)NSString *invoice_no;

@property(copy,nonatomic)NSString *ship_time;

@property(copy,nonatomic)NSString *delay_time;

@property(copy,nonatomic)NSString *receive_time;

@property(copy,nonatomic)NSString *receive_message;

@property(copy,nonatomic)NSString *commis_rate;

@end
