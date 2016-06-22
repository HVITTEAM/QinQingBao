//
//  MarketOrderSubmitController.h
//  QinQingBao
//
//  Created by shi on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MassageModel.h"
#import "ServiceItemModel.h"

@interface MarketOrderSubmitController : UIViewController

@property(strong,nonatomic)MassageModel *dataItem;

/**
 *  店铺资料
 */
@property (nonatomic, retain) ServiceItemModel *shopItem;

@end
