//
//  PayHeadCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/9.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceItemModel.h"
#import "OrderItem.h"

@interface PayHeadCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;

+ (PayHeadCell*) payHeadCell;

@property (nonatomic, retain) ServiceItemModel *item;
@property (nonatomic, retain) OrderItem *orderItem;

@end
