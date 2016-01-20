//
//  OrderResultModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/16.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderResultModel : NSObject
@property(nonatomic,copy)NSString *order_sn;
@property(nonatomic,copy)NSString *pay_sn;
@property(nonatomic,copy)NSString *store_id;
@property(nonatomic,copy)NSString *store_name;
@property(nonatomic,copy)NSString *buyer_id;
@property(nonatomic,copy)NSString *buyer_name;
@property(nonatomic,copy)NSString *buyer_email;
@property(nonatomic,copy)NSString *add_time;
@property(nonatomic,copy)NSString *payment_code;
@property(nonatomic,copy)NSString *order_state;
@property(nonatomic,copy)NSString *order_amount;
@property(nonatomic,copy)NSString *shipping_fee;
@property(nonatomic,copy)NSString *goods_amount;
@property(nonatomic,copy)NSString *order_from;
@property(nonatomic,copy)NSString *order_id;

@end
