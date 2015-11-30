//
//  QCListViewController.h
//  QCSliderTableView
//
//  Created by “ 邵鹏 on 14-4-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CommonOrderCell.h"
#import "OrderFormDetailController.h"
#import "CancelOrderController.h"
#import "EvaluationController.h"


@interface QCListViewController : UITableViewController

- (void)viewDidCurrentView;

@property (nonatomic, assign) UINavigationController *nav;

@end

