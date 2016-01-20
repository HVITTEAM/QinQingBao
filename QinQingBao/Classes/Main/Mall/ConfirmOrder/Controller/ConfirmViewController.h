//
//  ConfirmViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreModel.h"

@interface ConfirmViewController : UIViewController
//需要下单的商品数组
@property (nonatomic, retain) NSMutableArray *goodsArr;

@property (nonatomic, assign) BOOL fromCart;

@property (nonatomic, retain) StoreModel *storeModel;
@end
