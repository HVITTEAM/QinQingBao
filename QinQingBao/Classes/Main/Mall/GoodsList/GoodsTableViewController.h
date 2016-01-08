//
//  OrderTableViewController.h
//  QinQinBao
//
//  Created by 董徐维 on 15/6/15.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListViewController.h"


@interface GoodsTableViewController : UIViewController

@property (nonatomic, retain) UIScrollView *scrollView;

@property(nonatomic, retain) NSMutableArray *array;//创建一个数组属性 作为top菜单的数据源

/**标记页面来源，默认是空，为个人服务订单，否则为首页某个人的服务订单*/
@property(nonatomic, copy) NSString *viewOwer;

@property (nonatomic, strong) GoodsListViewController *vc1;
@property (nonatomic, strong) GoodsListViewController *vc2;
@property (nonatomic, strong) GoodsListViewController *vc3;
@property (nonatomic, strong) GoodsListViewController *vc4;

@end
