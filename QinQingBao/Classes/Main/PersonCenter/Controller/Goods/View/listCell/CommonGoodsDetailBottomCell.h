//
//  CommonGoodsDetailBottomCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonGoodsModel.h"
#import "ExtendOrderGoodsModel.h"

@interface CommonGoodsDetailBottomCell : UITableViewCell
+(CommonGoodsDetailBottomCell *) commonGoodsDetailBottomCell;

-(void)setitemWithData:(CommonGoodsModel *)item;

@end
