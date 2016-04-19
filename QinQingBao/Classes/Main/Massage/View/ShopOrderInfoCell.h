//
//  ShopOrderInfoCell.h
//  QinQingBao
//
//  Created by shi on 16/4/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceItemModel.h"

@interface ShopOrderInfoCell : UITableViewCell

+(instancetype)createShopOrderInfoCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)idx;
@property (nonatomic, retain) ServiceItemModel *item;

@end
