//
//  ShopCarModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCarModel : NSObject
@property(nonatomic,copy)NSString *cart_id;
@property(nonatomic,copy)NSString *buyer_id;
@property(nonatomic,copy)NSString *store_id;
@property(nonatomic,copy)NSString *store_name;
@property(nonatomic,copy)NSString *goods_id;
@property(nonatomic,copy)NSString *goods_name;
@property(nonatomic,copy)NSString *goods_price;
@property(nonatomic,copy)NSString *goods_num;
@property(nonatomic,copy)NSString *goods_image;
@property(nonatomic,copy)NSString *bl_id;
@property(nonatomic,copy)NSString *goods_image_url;
@property(nonatomic,copy)NSString *goods_sum;
@end
