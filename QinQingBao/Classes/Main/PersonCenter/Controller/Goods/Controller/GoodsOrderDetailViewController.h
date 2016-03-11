//
//  GoodsOrderDetailViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonGoodsModel.h"


@interface GoodsOrderDetailViewController : UIViewController

@property (nonatomic, retain) CommonGoodsModel *item;
/**订单付款成功之后跳到该界面传入id**/
@property (nonatomic, copy) NSString *orderID;

@end
