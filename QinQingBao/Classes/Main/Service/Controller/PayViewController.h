//
//  PayViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/8.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayHeadCell.h"
#import "PayButtonCell.h"
#import "ServiceItemModel.h"
#import "OrderItem.h"

@interface PayViewController : UITableViewController

@property (nonatomic, retain) ServiceItemModel *serviceDetailItem;
@property (nonatomic, retain) OrderItem *orderItem;


@end
