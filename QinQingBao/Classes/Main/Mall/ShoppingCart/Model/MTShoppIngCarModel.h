//
//  MTShoppIngCarModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MTShopViewModel.h"
#import "MTCommodityModel.h"

@class MTCommodityModel;

@interface MTShoppIngCarModel : NSObject

/**购物车id**/
@property(nonatomic,copy)NSString *item_id;
@property(nonatomic,copy)NSString *goods_id;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)NSString *item_size;
@property(nonatomic,strong)MTCommodityModel *item_info;
@property(nonatomic,assign)BOOL isSelect;

@property(nonatomic,assign)BOOL isEdit;

@property(nonatomic,assign)NSInteger type;

@property(nonatomic,weak)MTShopViewModel *vm;
@end
