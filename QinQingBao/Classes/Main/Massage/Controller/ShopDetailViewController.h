//
//  ShopDetailViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/4/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceItemModel.h"

@interface ShopDetailViewController : UITableViewController


@property (nonatomic, copy) NSString *iid;

/**
 *  店铺资料
 */
@property (nonatomic, retain) ServiceItemModel *shopItem;


@end
