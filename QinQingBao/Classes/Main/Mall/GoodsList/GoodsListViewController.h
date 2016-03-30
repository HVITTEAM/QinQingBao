//
//  QCListViewController.h
//  QCSliderTableView
//
//  Copyright (c) 2014年 Scasy. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CommonOrderCell.h"
#import "CancelOrderController.h"
#import "EvaluationController.h"


@interface GoodsListViewController : UITableViewController

- (void)viewDidCurrentView;

@property (nonatomic, assign) UINavigationController *nav;

/**
 *  没有数据可以刷新的事件
 */
@property (nonatomic, copy) void (^noneResultHandler)();

@property (nonatomic, copy) NSString *gc_id;
@property (nonatomic, copy) NSString *keyWords;


@end

