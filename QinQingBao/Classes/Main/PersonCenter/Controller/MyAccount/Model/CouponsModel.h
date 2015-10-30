//
//  CouponsModel.h
//  QinQingBao
//
//  Created by 董徐维 on 15/10/29.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponsModel : NSObject
/**代金券编号**/
@property (nonatomic, copy) NSString *voucher_id;
/**代金券所有者id **/
@property (nonatomic, copy) NSString *voucher_owner_id;
/**代金券编码**/
@property (nonatomic, copy) NSString *voucher_code;
/**代金券模版编号**/
@property (nonatomic, copy) NSString *voucher_t_id;
/**代金券标题**/
@property (nonatomic, copy) NSString *voucher_title;
/**代金券描述**/
@property (nonatomic, copy) NSString *voucher_desc;
/**代金券有效期开始时间 **/
@property (nonatomic, copy) NSString *voucher_start_date;
/**代金券有效期结束时间**/
@property (nonatomic, copy) NSString *voucher_end_date;
/**代金券面额**/
@property (nonatomic, copy) NSString *voucher_price;
/**代金券使用时的订单限额**/
@property (nonatomic, copy) NSString *voucher_limit;
/**代金券的店铺id**/
@property (nonatomic, copy) NSString *voucher_store_id;
/**代金券状态(1-未用,2-已用,3-过期,4-收回) **/
@property (nonatomic, copy) NSString *voucher_state;
/**代金券发放日期**/
@property (nonatomic, copy) NSString *voucher_active_date;
/**代金券类别**/
@property (nonatomic, copy) NSString *voucher_type;
/**代金券所有者名称**/
@property (nonatomic, copy) NSString *voucher_owner_name;
/**使用该代金券的订单编号**/
@property (nonatomic, copy) NSString *voucher_order_id;
@end
