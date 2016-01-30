//
//  SpecialGoodsModel.h
//  QinQingBao
//
//  Created by shi on 16/1/27.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommodityModel: NSObject

@property(copy,nonatomic)NSString *goods_id;              //商品id

@property(copy,nonatomic)NSString *store_id;              //店铺id

@property(copy,nonatomic)NSString *goods_name;               //商品名称

@property(copy,nonatomic)NSString *goods_image;             //商品图片 url

@property(copy,nonatomic)NSString *goods_price;            //商品价格

@property(copy,nonatomic)NSString *goods_marketprice;      //商品促销价格

@property(copy,nonatomic)NSString *goods_promotion_price;  //市场价

@end


