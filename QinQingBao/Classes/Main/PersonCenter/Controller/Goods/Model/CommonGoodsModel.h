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
@property(nonatomic,copy)NSString *add_time;
@property(nonatomic,copy)NSString *pay_sn;
@property(nonatomic,copy)NSString *pay_amount;
@end
