//
//  MarketDeatilViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/6/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceItemModel.h"

@interface MarketDeatilViewController : UITableViewController
@property (nonatomic, copy) NSString *iid;


/**
 *  店铺资料
 */
@property (nonatomic, retain) ServiceItemModel *shopItem;
@end
