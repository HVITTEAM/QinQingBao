//
//  DeliverInfoModel.h
//  QinQingBao
//
//  Created by shi on 16/6/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliverInfoModel : NSObject

@property(nonatomic,strong)NSArray *deliver_info;

@property(nonatomic,copy)NSString *express_name;

@property(nonatomic,copy)NSString *shipping_code;

@property(nonatomic,copy)NSString *state;

@end
