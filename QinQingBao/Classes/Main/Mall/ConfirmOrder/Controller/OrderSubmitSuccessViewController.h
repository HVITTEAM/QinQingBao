//
//  OrderSubmitSuccessViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/16.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderResultModel.h"

@interface OrderSubmitSuccessViewController : UIViewController



@property (nonatomic, retain) UINavigationController *nav;

@property (nonatomic, retain) OrderResultModel *orderModel;

@property (nonatomic, copy) void (^cancelClick)(void);

@end
