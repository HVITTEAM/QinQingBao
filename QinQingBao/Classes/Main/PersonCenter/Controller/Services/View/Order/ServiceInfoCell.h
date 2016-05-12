//
//  ServiceInfoCell.h
//  QinQingBao
//
//  Created by shi on 16/3/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;

@interface ServiceInfoCell : UITableViewCell

@property(strong,nonatomic)NSDateFormatter *formatterIn;        //时期格式化对象

@property(strong,nonatomic)NSDateFormatter *formatterOut;        //时期格式化对象

+(instancetype)createServiceInfoCellWithTableView:(UITableView *)tableview;

-(void)setDataWithOrderModel:(OrderModel *)orderModel;

@end
