//
//  ServiceInfoEmailCell.h
//  QinQingBao
//
//  Created by shi on 16/7/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;

@interface ServiceInfoEmailCell : UITableViewCell

@property(strong,nonatomic)NSDateFormatter *formatterIn;        //时期格式化对象

@property(strong,nonatomic)NSDateFormatter *formatterOut;        //时期格式化对象

+(instancetype)createCellWithTableView:(UITableView *)tableview;

-(void)setDataWithOrderModel:(OrderModel *)orderModel;

@end
