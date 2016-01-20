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
@property (strong, nonatomic) IBOutlet UILabel *paysnLab;
@property (strong, nonatomic) IBOutlet UILabel *alisnLab;
@property (strong, nonatomic) IBOutlet UILabel *createLab;
@property (strong, nonatomic) IBOutlet UILabel *paytimeLab;
@property (strong, nonatomic) IBOutlet UILabel *deliverLab;
@property (strong, nonatomic) IBOutlet UILabel *dealLab;

@end
