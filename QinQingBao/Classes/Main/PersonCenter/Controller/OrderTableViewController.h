//
//  OrderTableViewController.h
//  QinQinBao
//
//  Created by 董徐维 on 15/6/15.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCSlideSwitchView.h"
#import "QCListViewController.h"


@interface OrderTableViewController : UIViewController<QCSlideSwitchViewDelegate>


@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, strong) QCSlideSwitchView *slideSwitchView;

@property(nonatomic, retain) NSMutableArray *array;//创建一个数组属性 作为top菜单的数据源

@property(nonatomic, retain) NSMutableArray *dataProvider;//创建一个数组属性

/**标记页面来源，默认是空，为个人服务订单，否则为首页某个人的服务订单*/
@property(nonatomic, copy) NSString *viewOwer;



@property (nonatomic, strong) QCListViewController *vc1;
@property (nonatomic, strong) QCListViewController *vc2;
@property (nonatomic, strong) QCListViewController *vc3;
@property (nonatomic, strong) QCListViewController *vc4;
@property (nonatomic, strong) QCListViewController *vc5;
@property (nonatomic, strong) QCListViewController *vc6;

@end
