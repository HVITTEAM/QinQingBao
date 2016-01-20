//
//  MTCouponsViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponsViewController.h"
#import "UseCouponsViewController.h"

@interface MTCouponsViewController : UIViewController

@property (nonatomic, retain) UIScrollView *scrollView;

@property(nonatomic, retain) NSMutableArray *array;//创建一个数组属性 作为top菜单的数据源

/**标记页面来源，默认是空，为个人服务订单，否则为首页某个人的服务订单*/
@property(nonatomic, copy) NSString *viewOwer;

@property (nonatomic, strong) CouponsViewController *vc1;
@property (nonatomic, strong) CouponsViewController *vc2;
@property (nonatomic, strong) CouponsViewController *vc3;
@end
