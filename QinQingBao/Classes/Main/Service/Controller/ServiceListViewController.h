//
//  ServiceListViewController.h
//  QinQinBao
//
//  Created by 董徐维 on 15/6/30.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceListCell.h"
#import "PlaceOrderController.h"
#import "OrderDetailViewController.h"



@interface ServiceListViewController : UITableViewController

@property (nonatomic ,retain) OrderDetailViewController *palceView;

@end
