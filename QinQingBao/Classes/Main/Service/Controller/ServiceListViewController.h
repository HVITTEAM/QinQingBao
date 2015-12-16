//
//  ServiceListViewController.h
//  QinQinBao
//
//  Created by 董徐维 on 15/6/30.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceListCell.h"
#import "ServiceDetailViewController.h"
#import "ServiceTypeModel.h"
#import "ServicesDatas.h"



@interface ServiceListViewController : UIViewController

@property (nonatomic, retain) ServiceTypeModel *item;

//第二级服务分类
@property (nonatomic, retain) ServiceTypeModel *selected2edItem;

@end
