//
//  PaySettlementCell.h
//  QinQingBao
//
//  Created by shi on 16/3/25.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "CouponsModel.h"

@interface PaySettlementCell : UITableViewCell

@property(copy)void(^couponHandle)(void);      //代金券按钮点击回调

+(instancetype)createPaySettlementCellWithTableView:(UITableView *)tableview;

-(void)setDataWithOrderModel:(OrderModel *)orderModel couponsModel:(CouponsModel*)aCouponModel;

@end
