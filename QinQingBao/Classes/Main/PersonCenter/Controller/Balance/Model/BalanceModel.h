//
//  BalanceTotal.h
//  QinQingBao
//
//  Created by shi on 16/5/6.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BalanceModel : NSObject

@property(copy,nonatomic)NSString *member_id;

@property(copy,nonatomic)NSString *available_rc_balance;

@property(strong,nonatomic)NSMutableArray *log;

@end
