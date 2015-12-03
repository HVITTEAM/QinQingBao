//
//  ServiceDetailCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/9.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceItemModel.h"

@interface ServiceDetailCell : UITableViewCell

@property (nonatomic, retain) ServiceItemModel *itemInfo;

+(ServiceDetailCell *)serviceCell;
@end
