//
//  OrderRefundViewController.h
//  QinQingBao
//
//  Created by shi on 16/5/19.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderModel;

@interface OrderRefundViewController : UIViewController

@property(strong,nonatomic)OrderModel *orderModel;      //选中的订单模型

@property (nonatomic, copy) void (^doneHandlerClick)();

@end
