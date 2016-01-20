//
//  GoodsMiddleTopCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonGoodsModel.h"

@interface GoodsMiddleTopCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *statusLab;

+(GoodsMiddleTopCell *) goodsMiddleTopCell;

-(void)setitemWithData:(CommonGoodsModel *)item;
@end
