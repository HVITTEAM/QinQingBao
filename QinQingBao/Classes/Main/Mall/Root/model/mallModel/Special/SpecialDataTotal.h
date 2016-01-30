//
//  SpecialDataTotal.h
//  QinQingBao
//
//  Created by shi on 16/1/27.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialDataTotal : NSObject

@property(strong,nonatomic)NSMutableArray *data;            //专题商品数组

@property(copy,nonatomic)NSString *count;                   //商品个数

@property(copy,nonatomic)NSString *url;                     //图片组装路径即图片中间 url

@property(copy,nonatomic)NSString *title;                     //图片组装路径即图片中间 url

// "url": "/shop/data/upload/shop/store/goods/"    图片路径 域名/url/店铺id/goods_image

@end




