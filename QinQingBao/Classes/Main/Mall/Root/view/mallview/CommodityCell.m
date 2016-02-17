//
//  GoodsCell.m
//  QinQingBao
//
//  Created by shi on 16/1/26.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommodityCell.h"

@interface CommodityCell ()

@property (weak, nonatomic) IBOutlet UILabel *commodityNameLb;                //商品名字

@property (weak, nonatomic) IBOutlet UILabel *oldpriceLb;                     //原价格

@property (weak, nonatomic) IBOutlet UILabel *newpriceLb;                     //现价

@end

@implementation CommodityCell

- (void)awakeFromNib {
    //设置边框
    self.layer.cornerRadius = 5.0f;
    self.layer.borderColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0].CGColor;
    self.layer.borderWidth = 0.5;
}

/**
 *  设置原价
 */
-(void)setOldprice:(NSString *)oldprice
{
    NSString *price = [NSString stringWithFormat:@"￥%@",oldprice];
    NSDictionary *attribtDic = @{
                                   NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)
                                 };
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:price
                                                                                  attributes:attribtDic];
    self.oldpriceLb.attributedText = attribtStr;
}

/**
 *  设置现价
 */
-(void)setNewprice:(NSString *)newprice
{
    self.newpriceLb.text = [NSString stringWithFormat:@"￥%@",newprice];
}

/**
 *  设置商品名称
 */
-(void)setCommodityName:(NSString *)commodityName
{
    self.commodityNameLb.text = commodityName;
}

@end
