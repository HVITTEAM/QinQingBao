//
//  ManipulateOrderViewController.h
//  QinQingBao
//
//  Created by shi on 16/4/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MassageModel.h"
#import "ServiceItemModel.h"

@interface ShopOrderViewController : UIViewController

@property (nonatomic, retain) MassageModel *dataItem;

/**
 *  店铺资料
 */
@property (nonatomic, retain) ServiceItemModel *shopItem;

@end
