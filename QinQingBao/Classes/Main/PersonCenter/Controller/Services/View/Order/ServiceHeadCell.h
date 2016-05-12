//
//  ServiceHeadCell.h
//  QinQingBao
//
//  Created by shi on 16/5/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;

@interface ServiceHeadCell : UITableViewCell

+(instancetype)createCellWithTableView:(UITableView *)tableView;

-(void)setDataWithOrderModel:(OrderModel *)aModel;

@end
