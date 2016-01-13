//
//  PriceDetailCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsInfoModel.h"


@interface PriceDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *oldPriceLeftpadding;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UILabel *oldPriceLab;
@property (strong, nonatomic) IBOutlet UILabel *desLab;
@property (strong, nonatomic) IBOutlet UILabel *expressLab;
@property (strong, nonatomic) IBOutlet UILabel *sellCount;
@property (strong, nonatomic) IBOutlet UILabel *stockLab;

+(PriceDetailCell *)priceDetailCell;
- (void)setItem:(GoodsInfoModel *)goodsInfo;

@end
