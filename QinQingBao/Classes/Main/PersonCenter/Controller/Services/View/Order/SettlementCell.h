//
//  SettlementCell.h
//  QinQingBao
//
//  Created by shi on 16/3/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface SettlementCell : UITableViewCell

+(instancetype)createSettlementCellWithTableView:(UITableView *)tableview;

-(void)setDataWithOrderModel:(OrderModel *)orderModel;

@end
