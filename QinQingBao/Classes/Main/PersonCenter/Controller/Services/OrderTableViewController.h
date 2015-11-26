//
//  OrderTableViewController.h
//  QinQinBao
//
//  Created by 董徐维 on 15/6/15.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCListViewController.h"


@interface OrderTableViewController : UIViewController


@property (nonatomic, retain) UIScrollView *scrollView;

@property(nonatomic, retain) NSMutableArray *array;//创建一个数组属性 作为top菜单的数据源

/**标记页面来源，默认是空，为个人服务订单，否则为首页某个人的服务订单*/
@property(nonatomic, copy) NSString *viewOwer;



@property (nonatomic, strong) QCListViewController *vc1;
@property (nonatomic, strong) QCListViewController *vc2;
@property (nonatomic, strong) QCListViewController *vc3;
@property (nonatomic, strong) QCListViewController *vc4;
@property (nonatomic, strong) QCListViewController *vc5;

@end
