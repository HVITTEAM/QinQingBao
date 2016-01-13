//
//  CommodityInfoCell.h
//  QinQingBao
//
//  Created by Dual on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommodityInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *commodityImage;  //图片
@property (weak, nonatomic) IBOutlet UILabel *commodityName; //商品名
@property (weak, nonatomic) IBOutlet UILabel *commodityPrice; //价格
@property (weak, nonatomic) IBOutlet UILabel *commodityQuantity; //数量

+ (CommodityInfoCell *)commodityInfoCell;

@end
