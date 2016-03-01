//
//  RefundReasonMode.h
//  QinQingBao
//
//  Created by shi on 16/2/26.
//  Copyright © 2016年 董徐维. All rights reserved.
//

//"reason_id": "99",
//"reason_info": "不能按时发货",
//"sort": "123",
//"update_time": "1393480261"

#import <Foundation/Foundation.h>

@interface RefundReasonMode : NSObject

@property(copy,nonatomic)NSString *reason_id;                  //退货原理id

@property(copy,nonatomic)NSString *reason_info;                //退货原理内容

@property(copy,nonatomic)NSString *sort;

@property(copy,nonatomic)NSString *update_time;

@end
