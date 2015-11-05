//
//  OrderDetailViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/6.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceListCell.h"
#import "PlaceOrderHeadView.h"
#import "EvaluationCell.h"
#import "BusinessInfoCell.h"
#import "ServiceHeadView.h"
#import "ServiceDetailCell.h"
#import "OrderSubmitController.h"
#import "QueryAllEvaluationController.h"

#import "ServiceItemModel.h"



@interface OrderDetailViewController : UITableViewController

@property (nonatomic, retain) PlaceOrderHeadView *headView;
@property (nonatomic, retain) ServiceItemModel *selectedItem;
@end
