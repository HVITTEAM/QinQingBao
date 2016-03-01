//
//  GoodsSelectedViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsInfoModel.h"
#import "GoodsHeadViewController.h"

@interface GoodsSelectedViewController : UIViewController

@property (nonatomic, assign) OrderType *type;

//添加购物车提交block
@property (nonatomic, copy) void (^submitClick)(BOOL isSuccess);

@property (nonatomic, copy) void (^orderClick)(NSString *number);

@property (nonatomic,strong) NSString *goodsID;

@property (nonatomic, strong) UIViewController *parentVC;

//商品规格参数分类
@property (nonatomic, retain)  NSDictionary *specnameDict;
//商品规格参数分类的值
@property (nonatomic, retain)  NSDictionary *specvalueDict;
//商品规格参数分类对应的id池
@property (nonatomic, retain)  NSDictionary *speclistDict;

/**商品信息model*/
@property (nonatomic, retain) GoodsInfoModel *goodsInfo;

@end
