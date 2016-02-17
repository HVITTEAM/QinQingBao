//
//  SpecialData.h
//  QinQingBao
//
//  Created by shi on 16/1/28.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpecialDataItem.h"

@interface SpecialData : NSObject


@property(copy,nonatomic)NSString *item_id;

@property(copy,nonatomic)NSString *special_id;              //专题id

@property(copy,nonatomic)NSString *item_type;

@property(copy,nonatomic)NSString *item_usable;

@property(copy,nonatomic)NSString *item_sort;

@property(copy,nonatomic)NSString *usable_class;

@property(copy,nonatomic)NSString *usable_text;

@property(strong,nonatomic)SpecialDataItem *item_data;

@end
