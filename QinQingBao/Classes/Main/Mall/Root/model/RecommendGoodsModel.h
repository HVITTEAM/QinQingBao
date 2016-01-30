//
//  RecommendGoodsModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/27.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendGoodsModel : NSObject
@property(nonatomic,copy)NSString *store_id;
@property(nonatomic,copy)NSString *goods_id;
@property(nonatomic,copy)NSString *goods_name;
@property(nonatomic,copy)NSString *goods_price;
@property(nonatomic,copy)NSString *goods_image;
@property(nonatomic,copy)NSString *goods_marketprice;
@property(nonatomic,copy)NSString *goods_promotion_price;

@end
