//
//  PaymentViewController.h
//  QinQingBao
//
//  Created by shi on 16/5/5.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;

@interface PaymentViewController : UITableViewController

@property(strong,nonatomic)OrderModel *orderModel;      //选中的订单模型

@end