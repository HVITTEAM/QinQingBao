//
//  ServiceListViewController.h
//  QinQinBao
//
//  Created by 董徐维 on 15/6/30.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceListCell.h"
#import "OrderDetailViewController.h"
#import "ServiceTypeModel.h"
#import "ServicesDatas.h"



@interface ServiceListViewController : UIViewController

@property (nonatomic, retain) ServiceTypeModel *item;

@end
