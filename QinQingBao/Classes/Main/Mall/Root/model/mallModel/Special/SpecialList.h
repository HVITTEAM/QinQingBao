//
//  SpecialList.h
//  QinQingBao
//
//  Created by shi on 16/1/27.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialList : NSObject

@property(strong,nonatomic)NSMutableArray *data;             //专题数组 元素为SpecialModel对象

@property(copy,nonatomic)NSString *count;                  //专题个数

@property(copy,nonatomic)NSString *url;                     //专题图片组装路径即图片的中间 url
//"url": "/shop/data/upload/mobile/special/s0/"            组装路径 域名/url/image

@end
