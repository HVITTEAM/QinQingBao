//
//  RecommendGoodsCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/8/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsInfoModel;

@interface RecommendGoodsCell : UITableViewCell

+ (RecommendGoodsCell*) recommendGoodsCell;


@property (nonatomic, strong) GoodsInfoModel *goodsItem;

@property (nonatomic, strong) UIViewController *parnetVC;

@property (nonatomic, copy) void (^changeClick)(UIButton *btn);


@end
