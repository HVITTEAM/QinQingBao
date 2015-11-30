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
#import "ServiceTypeModel.h"



@interface ServiceDetailViewController : UITableViewController

@property (nonatomic, retain) PlaceOrderHeadView *headView;
@property (nonatomic, retain) ServiceItemModel *selectedItem;
//服务类别
@property (nonatomic, retain) ServiceTypeModel *serviceTypeItem;
@end
