//
//  CouponsViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/11/20.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonCouponsCell.h"
#import "CouponsModel.h"

@interface UseCouponsViewController : UITableViewController


@property (nonatomic, copy) void (^selectedClick)(CouponsModel *item);

@property (nonatomic, assign) UINavigationController *nav;
- (void)viewDidCurrentView;
//订单总金额
@property (nonatomic, retain) NSString *totalPrice;

//当前选择的优惠券
@property (nonatomic, retain) CouponsModel *selectedModel;

@end
