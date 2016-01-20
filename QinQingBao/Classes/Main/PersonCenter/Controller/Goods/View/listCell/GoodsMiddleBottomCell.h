//
//  GoodsMiddleBottomCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonGoodsModel.h"

@interface GoodsMiddleBottomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *feeLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UIButton *cantactBtn;
@property (strong, nonatomic) IBOutlet UIButton *telBtn;
@property (strong, nonatomic) IBOutlet UIView *bottomLine;

+(GoodsMiddleBottomCell *) goodsMiddleBottomCell;

-(void)setitemWithData:(CommonGoodsModel *)item;
@end
