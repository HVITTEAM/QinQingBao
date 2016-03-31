//
//  OrderManCell.h
//  QinQingBao
//
//  Created by shi on 16/3/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OrderManCell : UITableViewCell

@property(strong,nonatomic)NSString *nameStr;

@property(strong,nonatomic)NSString *phoneStr;

@property(strong,nonatomic)NSString *addressStr;

+(instancetype)createOrderManCellWithTableView:(UITableView *)tableview;

-(CGFloat)setupCellUI;

@end
