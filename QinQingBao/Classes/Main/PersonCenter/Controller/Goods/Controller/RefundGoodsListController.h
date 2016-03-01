//
//  RefundGoodsListController.h
//  QinQingBao
//
//  Created by shi on 16/2/29.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefundGoodsListController : UITableViewController

@property (nonatomic, assign) UINavigationController *nav;

/**
 *  加载第一页数据
 */
-(void)loadFirstPageRefundListData;

@end
