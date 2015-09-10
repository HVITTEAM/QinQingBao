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

@property (nonatomic,retain) NSMutableArray *dataProvider;

@property (nonatomic, assign) UINavigationController *nav;

@property (nonatomic, retain) OrderFormDetailController *detailForm;
@property (nonatomic, retain) CancelOrderController *cancelView;
@property (nonatomic, retain) EvaluationController *evaluaView;

@end

