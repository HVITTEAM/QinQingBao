//
//  GroupbuyTotal.h
//  QinQingBao
//
//  Created by shi on 16/1/28.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupbuyTotal : NSObject

@property(copy,nonatomic)NSString *lunbo;                     //图片名称

@property(copy,nonatomic)NSString *lunbourl;                  //路径

@property(copy,nonatomic)NSString *count;                     //数据条数

@property(copy,nonatomic)NSString *url;                       //图片地址数

@property(strong,nonatomic)NSMutableArray *data;              //抢购团购数据

@end
