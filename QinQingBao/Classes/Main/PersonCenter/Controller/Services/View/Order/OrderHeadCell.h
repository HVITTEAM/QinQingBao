//
//  OrderHeadCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/11/27.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceItemModel.h"

@interface OrderHeadCell : UITableViewCell

+ (OrderHeadCell*) orderHeadCell;

@property (strong, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *contentLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleLabWidth;

@property (nonatomic, retain) ServiceItemModel *item;

@end
