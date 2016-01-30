//
//  GoodsCell.h
//  QinQingBao
//
//  Created by shi on 16/1/26.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommodityCell : UICollectionViewCell

@property(strong,nonatomic)NSString *oldprice;             //旧价格

@property(strong,nonatomic)NSString *newprice;             //新价格

@property(strong,nonatomic)NSString *commodityName;        //商品名称

@property (weak, nonatomic) IBOutlet UIImageView *commodityImgView;    //商品图片View

@end
