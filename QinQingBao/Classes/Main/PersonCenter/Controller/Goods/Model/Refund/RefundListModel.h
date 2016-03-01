//
//  RefundListModel.h
//  QinQingBao
//
//  Created by shi on 16/2/29.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefundListModel : NSObject

@property(copy,nonatomic)NSString *refund_id;

@property(copy,nonatomic)NSString *order_id;

@property(copy,nonatomic)NSString *order_sn;

@property(copy,nonatomic)NSString *refund_sn;

@property(copy,nonatomic)NSString *store_id;

@property(copy,nonatomic)NSString *store_name;

@property(copy,nonatomic)NSString *buyer_id;

@property(copy,nonatomic)NSString *buyer_name;

@property(copy,nonatomic)NSString *goods_id;                         //当为全部退款时，为 “0”

@property(copy,nonatomic)NSString *order_goods_id;                   //为order_goods表的索引值rec_id

@property(copy,nonatomic)NSString *goods_name;                      //当为全部退款时，默认为  “订单商品全部退款”

@property(copy,nonatomic)NSString *goods_num;                       //退款商品数量，当为全部退款时，默认为 “0”

@property(copy,nonatomic)NSString *refund_amount;          //退款金额，不得大于实付金额，当为全部退款时，等于实付金额

@property(copy,nonatomic)NSString *goods_image;            //当为全部退款时，为  空

@property(copy,nonatomic)NSString *order_goods_type;

@property(copy,nonatomic)NSString *refund_type;            //申请类型:1为退款,2为退货,默认为1

@property(copy,nonatomic)NSString *seller_state;            //卖家处理状态:1为待审核,2为同意,3为不同意,默认为1

@property(copy,nonatomic)NSString *refund_state;          //申请状态:1为处理中,2为待管理员处理,3为已完成,默认为1

@property(copy,nonatomic)NSString *return_type;           //退货类型:1为不用退货,2为需要退货,默认为1

@property(copy,nonatomic)NSString *order_lock;             //订单锁定类型:1为不用锁定,2为需要锁定,默认为1

@property(copy,nonatomic)NSString *goods_state;            //物流状态:1为待发货,2为待收货,3为未收到,4为已收货,默认为1

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

@property(copy,nonatomic)NSString *goods_image_url;

@end
