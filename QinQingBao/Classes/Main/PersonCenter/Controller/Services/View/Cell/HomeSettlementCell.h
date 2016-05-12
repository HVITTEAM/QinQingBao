//
//  HomeSettlementCell.h
//  QinQingBao
//
//  Created by shi on 16/5/5.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;

@interface HomeSettlementCell : UITableViewCell

@property(assign,nonatomic)BOOL isShowEvaluate;         //是否显示评价

@property(strong,nonatomic)NSDateFormatter *formatterIn;        //时期格式化对象

@property(strong,nonatomic)NSDateFormatter *formatterOut;        //时期格式化对象

@property(copy)void(^cellButtonTapCallBack)(UIButton *);

+(instancetype)createHomeSettlementCellWithTableView:(UITableView *)tableview;

-(void)setItem:(OrderModel *)item;

@end
