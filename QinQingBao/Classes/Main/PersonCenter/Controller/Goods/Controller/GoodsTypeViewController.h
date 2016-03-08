//
//  GoodsTypeViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/20.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsViewController.h"
#import "RefundGoodsListController.h"

@interface GoodsTypeViewController : UIViewController

/**标记页面来源，默认是空，为个人服务订单，否则为首页某个人的服务订单*/
@property(nonatomic, copy) NSString *viewOwer;

@property (nonatomic, strong) GoodsViewController *vc0;
@property (nonatomic, strong) GoodsViewController *vc1;
@property (nonatomic, strong) GoodsViewController *vc2;
@property (nonatomic, strong) GoodsViewController *vc3;
@property (nonatomic, strong) GoodsViewController *vc4;
@property (nonatomic, strong) RefundGoodsListController *vc5;

@end
