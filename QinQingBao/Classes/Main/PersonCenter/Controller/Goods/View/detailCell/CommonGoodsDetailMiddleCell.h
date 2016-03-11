//
//  CommonGoodsDetailMiddleCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtendOrderGoodsModel.h"

@interface CommonGoodsDetailMiddleCell : UITableViewCell
+(CommonGoodsDetailMiddleCell *) commonGoodsDetailMiddleCell;

-(void)setitemWithData:(ExtendOrderGoodsModel *)item;

@property (strong, nonatomic) IBOutlet UIButton *button;

@property (strong, nonatomic) IBOutlet UIView *topLine;

@property (strong, nonatomic) IBOutlet UIImageView *goodsIconImg;

@property (strong, nonatomic) IBOutlet UILabel *goodsTitleLab;

@property (strong, nonatomic) IBOutlet UILabel *priceLab;

@property (strong, nonatomic) IBOutlet UILabel *countLab;

//修改by swy
@property (copy,nonatomic)void(^refundOperation)(CommonGoodsDetailMiddleCell *);

@end
