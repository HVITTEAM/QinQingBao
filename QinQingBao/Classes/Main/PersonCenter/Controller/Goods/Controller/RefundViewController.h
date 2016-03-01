//
//  RefundViewController.h
//  QinQingBao
//
//  Created by shi on 16/2/25.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommonOrderModel,ExtendOrderGoodsModel;

@interface RefundViewController : UIViewController

@property(assign,nonatomic)BOOL isShowRefundType;           //是否显示退款类型

@property(strong,nonatomic)CommonOrderModel *orderInfo;      //选中的这个订单信息

@property (strong,nonatomic) ExtendOrderGoodsModel *orderGoodsModel;  //选中要退款的那个商品信息

@end
