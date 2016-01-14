//
//  CommonGoodsDetailHeadCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonGoodsModel.h"
#import "ExtendOrderGoodsModel.h"

@interface CommonGoodsDetailHeadCell : UITableViewCell

+(CommonGoodsDetailHeadCell *) commonGoodsDetailHeadCell;
@property (strong, nonatomic) IBOutlet UILabel *nameTitle;
@property (strong, nonatomic) IBOutlet UILabel *telLab;
@property (strong, nonatomic) IBOutlet UILabel *addressLab;
@property (strong, nonatomic) IBOutlet UIView *line;
@property (strong, nonatomic) IBOutlet UILabel *invoiceLab;

-(void)setitemWithData:(CommonGoodsModel *)item;
@end
