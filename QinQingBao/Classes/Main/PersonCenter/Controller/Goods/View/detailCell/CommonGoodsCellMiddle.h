//
//  CommonGoodsCellMiddle.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonGoodsModel.h"
#import "RefundListModel.h"

@interface CommonGoodsCellMiddle : UITableViewCell

+(CommonGoodsCellMiddle *) commonGoodsCellMiddle;

@property (strong, nonatomic) IBOutlet UIView *topLine;

@property (strong, nonatomic) IBOutlet UIImageView *goodsIconImg;

@property (strong, nonatomic) IBOutlet UILabel *goodsTitleLab;

@property (strong, nonatomic) IBOutlet UILabel *priceLab;

@property (strong, nonatomic) IBOutlet UILabel *countLab;

@property (strong, nonatomic) IBOutlet UILabel *refundLab;

-(void)setitemWithData:(CommonGoodsModel *)item;

/**
 *  头部状态cell,退款退货时使用
 */
-(void)setItemWithRefundData:(RefundListModel *)item;
@end
