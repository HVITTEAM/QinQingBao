//
//  DeliverViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/30.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonGoodsModel.h"
#import "CommonOrderModel.h"

@interface DeliverViewController : UIViewController

/**item和orderId只传其中一个即可,商品物流时需要传*/
@property (nonatomic, retain) CommonGoodsModel *item;     //商品数据(包含了订单id)

/**item和orderId只传其中一个即可,商品物流时需要传*/
@property (nonatomic,copy) NSString *orderId;             //商品的订单id

/**服务工单id,服务市场物流时需要传*/
@property (nonatomic,copy) NSString *wid;           //工单id

@end
