//
//  EvaluationViewController.h
//  QinQingBao
//
//  Created by shi on 16/5/19.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;

@interface EvaluationViewController : UITableViewController

@property(strong,nonatomic)OrderModel *orderModel;      //选中的订单模型

@end
